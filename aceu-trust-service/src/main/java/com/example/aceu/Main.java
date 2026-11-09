package com.example.aceu;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.helidon.webserver.WebServer;
import io.helidon.webserver.http.ServerRequest;
import io.helidon.webserver.http.ServerResponse;
import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;

import java.sql.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

public final class Main {
    private static final ObjectMapper JSON = new ObjectMapper();
    private static final PoolDataSource POOL = pool();
    private static final AtomicLong BORROWED = new AtomicLong();
    private static PoolDataSource pool() {
        try {
            PoolDataSource p = PoolDataSourceFactory.getPoolDataSource();
            p.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
            p.setURL(env("DB_URL", "jdbc:oracle:thin:@localhost:1521/FREEPDB1"));
            p.setUser(env("DB_USER", "aceu_app")); p.setPassword(env("DB_PASSWORD", "aceu_app_local_only"));
            p.setInitialPoolSize(Integer.parseInt(env("UCP_MIN", "2")));
            p.setMinPoolSize(Integer.parseInt(env("UCP_MIN", "2")));
            p.setMaxPoolSize(Integer.parseInt(env("UCP_MAX", "20")));
            p.setValidateConnectionOnBorrow(true); p.setSQLForValidateConnection("SELECT 1 FROM dual");
            p.setConnectionWaitTimeout(Integer.parseInt(env("UCP_WAIT_SECONDS", "3")));
            p.setSecondsToTrustIdleConnection(5);
            p.setInactiveConnectionTimeout(300);
            return p;
        } catch (SQLException e) { throw new ExceptionInInitializerError(e); }
    }
    private static String env(String k, String d) { return System.getenv().getOrDefault(k, d); }
    private static Connection connection() throws SQLException { BORROWED.incrementAndGet(); Connection c=POOL.getConnection(); c.setSchema("ACEU"); return c; }
    private static void send(ServerResponse res, int status, Object value) {
        res.status(status).send(value instanceof String s ? s : toJson(value));
    }
    private static String toJson(Object value) { try { return JSON.writeValueAsString(value); } catch (Exception e) { return "{}"; } }
    public static void main(String[] args) {
        WebServer server = WebServer.builder().port(Integer.parseInt(env("PORT", "8080")))
            .routing(r -> r.get("/health", Main::health)
                .post("/profiles", Main::createProfile)
                .get("/profiles/{id}/score", Main::score)
                .post("/rank", Main::rank)
                .post("/contest", Main::contest))
            .build().start();
        System.out.println("ACE-U service on http://localhost:" + server.port());
    }
    private static void health(ServerRequest req, ServerResponse res) {
        try {
            Map<String,Object> metrics=Map.of("status","ok","dbPool","UCP","min",POOL.getMinPoolSize(),"max",POOL.getMaxPoolSize(),
                "validateOnBorrow",POOL.getValidateConnectionOnBorrow(),"waitTimeoutSeconds",POOL.getConnectionWaitTimeout(),
                "borrowed",POOL.getBorrowedConnectionsCount(),"available",POOL.getAvailableConnectionsCount(),"totalBorrows",BORROWED.get());
            System.out.println("UCP_METRICS "+toJson(metrics)); send(res,200,metrics);
        } catch(SQLException e) { send(res,503,Map.of("status","unavailable","error",safe(e))); }
    }
    private static void createProfile(ServerRequest req, ServerResponse res) {
        try {
            JsonNode b = JSON.readTree(req.content().as(String.class));
            if (!b.path("consent").asBoolean(false)) { send(res, 400, Map.of("error", "explicit consent=true is required")); return; }
            String name=b.path("displayName").asText("Synthetic profile"), context=b.path("context").asText("general");
            try (Connection c=connection()) {
                c.setAutoCommit(false);
                try (PreparedStatement p=c.prepareStatement("INSERT INTO profiles(display_name,context_name,payload,skills_vector) VALUES(?,?,?,TO_VECTOR(?))",new String[]{"PROFILE_ID"})) {
                    p.setString(1,name);p.setString(2,context);p.setString(3,b.toString());p.setString(4,SkillVector.encode(b.path("skills")));p.executeUpdate();
                    long id;try(ResultSet k=p.getGeneratedKeys()){k.next();id=k.getLong(1);}
                    try(PreparedStatement cp=c.prepareStatement("INSERT INTO consent(profile_id,consented,scope) VALUES(?,'Y','score,rank')")){cp.setLong(1,id);cp.executeUpdate();}
                    try(PreparedStatement ap=c.prepareStatement("INSERT INTO artifacts(profile_id,artifact_type,skills_json,embedding,authored_at) VALUES(?,'authored',?,TO_VECTOR(?),SYSTIMESTAMP)")){
                        ap.setLong(1,id);ap.setString(2,b.path("authored_skills").isArray()?b.path("authored_skills").toString():"[]");ap.setString(3,SkillVector.encode(b.path("authored_skills")));ap.executeUpdate();
                    }
                    JsonNode interactions=b.path("interactions");
                    if(interactions.isArray()) try(PreparedStatement ip=c.prepareStatement("INSERT INTO interactions(profile_id,interaction_type,quality,reciprocity) VALUES(?,?,?,?)")) {
                        for(JsonNode it:interactions){ip.setLong(1,id);ip.setString(2,it.path("type").asText("unknown"));ip.setDouble(3,it.path("quality").asDouble(0));ip.setDouble(4,it.path("reciprocity").asDouble(0));ip.addBatch();} ip.executeBatch();
                    }
                    c.commit();send(res,201,Map.of("id",id,"consent",true));
                }
            }
        } catch(Exception e) { e.printStackTrace();send(res,500,Map.of("error",safe(e))); }
    }
    private static void score(ServerRequest req, ServerResponse res) {
        try {
            long id = Long.parseLong(req.path().pathParameters().get("id"));
            try (Connection c = connection(); CallableStatement call = c.prepareCall("{call aceu_service.score_profile(?)}")) { call.setLong(1,id); call.execute(); }
            try (Connection c = connection(); PreparedStatement p = c.prepareStatement("SELECT a_score,c_score,e_score,u_score,a_uncertainty,c_uncertainty,e_uncertainty,u_uncertainty,explanation FROM scores WHERE profile_id=? ORDER BY computed_at DESC FETCH FIRST 1 ROW ONLY")) {
                p.setLong(1,id); try (ResultSet r=p.executeQuery()) { if(!r.next()) { send(res,404,Map.of("error","profile not found or consent absent")); return; }
                    send(res,200,Map.of("profileId",id,"vector",Map.of("A",r.getDouble(1),"C",r.getDouble(2),"E",r.getDouble(3),"U",r.getDouble(4)),"uncertainty",Map.of("A",r.getDouble(5),"C",r.getDouble(6),"E",r.getDouble(7),"U",r.getDouble(8)),"explanation",r.getString(9))); }
            }
        } catch (SQLException e) { if(e.getErrorCode()==1403)send(res,404,Map.of("error","profile not found or consent absent"));else send(res,500,Map.of("error",safe(e))); } catch(Exception e){send(res,500,Map.of("error",safe(e)));}
    }
    private static void rank(ServerRequest req, ServerResponse res) {
        try {
            JsonNode b=JSON.readTree(req.content().as(String.class)); JsonNode w=b.path("weights");
            double wr=Math.max(0,w.path("relevance").asDouble(.5)),wt=Math.max(0,w.path("trust").asDouble(.3)),wd=Math.max(0,w.path("diversity").asDouble(.2));
            double total=wr+wt+wd;if(total==0){wr=.5;wt=.3;wd=.2;total=1;}wr/=total;wt/=total;wd/=total;
            JsonNode relevanceById=b.path("relevanceByProfile"); List<Map<String,Object>> rows=new ArrayList<>();
            String sql="SELECT p.profile_id,s.a_score,s.c_score,s.e_score,s.u_score FROM profiles p JOIN consent co ON co.profile_id=p.profile_id AND co.consented='Y' JOIN scores s ON s.profile_id=p.profile_id AND s.score_id=(SELECT MAX(s2.score_id) FROM scores s2 WHERE s2.profile_id=p.profile_id) FETCH FIRST 100 ROWS ONLY";
            try(Connection c=connection();PreparedStatement p=c.prepareStatement(sql);ResultSet r=p.executeQuery()){
                while(r.next()){long id=r.getLong(1);double relevance=relevanceById.path(Long.toString(id)).asDouble(b.path("relevance").asDouble(.5));
                    double trust=(r.getDouble(2)+r.getDouble(3)+r.getDouble(4)+r.getDouble(5))/4,diversity=r.getDouble(5);
                    rows.add(Map.of("profileId",id,"trust",trust,"relevance",relevance,"diversity",diversity,"rankScore",wr*relevance+wt*trust+wd*diversity));}
            }
            rows.sort((a,d)->Double.compare((double)d.get("rankScore"),(double)a.get("rankScore")));
            send(res,200,Map.of("weights",Map.of("relevance",wr,"trust",wt,"diversity",wd),"results",rows));
        }catch(Exception e){e.printStackTrace();send(res,500,Map.of("error",safe(e)));}
    }
    private static void contest(ServerRequest req, ServerResponse res) {
        try { JsonNode b=JSON.readTree(req.content().as(String.class)); long id=b.path("profileId").asLong(); String reason=b.path("reason").asText("");
            if(reason.isBlank()) { send(res,400,Map.of("error","reason is required")); return; }
            try(Connection c=connection(); PreparedStatement p=c.prepareStatement("INSERT INTO contest_log(profile_id,action,reason,proposed_value) SELECT ?, 'contest', ?, ? FROM dual WHERE EXISTS (SELECT 1 FROM profiles p JOIN consent co ON co.profile_id=p.profile_id AND co.consented='Y' WHERE p.profile_id=?)")) {
                p.setLong(1,id); p.setString(2,reason); if(b.has("proposedValue"))p.setDouble(3,b.get("proposedValue").asDouble());else p.setNull(3,Types.NUMERIC);p.setLong(4,id);
                int n=p.executeUpdate(); if(n==0){send(res,404,Map.of("error","profile not found or consent absent"));return;} send(res,201,Map.of("profileId",id,"status","open"));
            }
        } catch(Exception e){e.printStackTrace();send(res,500,Map.of("error",safe(e)));}
    }
    private static String safe(Exception e) { String s=e.getMessage(); return s==null?"database error":s.replaceAll("(?i)(password|token|secret)\\s*[=:]\\s*[^ ]+","$1=[redacted]"); }
}
