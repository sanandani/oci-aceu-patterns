package com.example.aceu;

import org.junit.jupiter.api.Test;
import java.sql.*;
import static org.junit.jupiter.api.Assertions.*;

class OracleIntegrationTest {
    @Test
    void oracle23aiSchemaVectorAndPlsqlScoringWorkTogether() throws Exception {
        String url=env("ACEU_IT_URL", "jdbc:oracle:thin:@localhost:1521/FREEPDB1");
        String user=env("ACEU_IT_USER", "aceu_app");
        String password=env("ACEU_IT_PASSWORD", "aceu_app_local_only");
        try(Connection c=DriverManager.getConnection(url,user,password)) {
            c.setSchema("ACEU");
            String payload="{\"skills\":[\"sql\",\"cloud\"],\"prior_skills\":[\"sql\"],\"roles\":[\"engineer\"],\"prior_roles\":[\"engineer\"],\"history\":[\"synthetic\"],\"authored_skills\":[\"sql\"],\"credibility_signals\":[{\"status\":\"verified\",\"strength\":0.9}],\"context_relevance\":0.9}";
            long id;
            try(PreparedStatement p=c.prepareStatement("INSERT INTO profiles(display_name,context_name,payload,skills_vector) VALUES('Synthetic integration fixture','ci',?,TO_VECTOR('[0,1,0,0,0,0,1,0,0,0]'))",new String[]{"PROFILE_ID"})) {
                p.setString(1,payload);p.executeUpdate();try(ResultSet k=p.getGeneratedKeys()){assertTrue(k.next());id=k.getLong(1);}
            }
            try(PreparedStatement p=c.prepareStatement("INSERT INTO consent(profile_id,consented,scope) VALUES(?,'Y','score,rank')")){p.setLong(1,id);p.executeUpdate();}
            try(PreparedStatement p=c.prepareStatement("INSERT INTO interactions(profile_id,interaction_type,quality,reciprocity) VALUES(?,'mentoring',0.9,0.8)")){p.setLong(1,id);p.executeUpdate();}
            try(CallableStatement p=c.prepareCall("{call aceu_service.score_profile(?)}")){p.setLong(1,id);p.execute();}
            try(PreparedStatement p=c.prepareStatement("SELECT a_score,c_score,e_score,u_score,a_uncertainty,c_uncertainty,e_uncertainty,u_uncertainty FROM scores WHERE profile_id=? ORDER BY score_id DESC FETCH FIRST 1 ROW ONLY")) {
                p.setLong(1,id);try(ResultSet r=p.executeQuery()){assertTrue(r.next());for(int i=1;i<=8;i++)assertTrue(r.getDouble(i)>=0 && r.getDouble(i)<=1);assertTrue(r.getDouble(4)>0,"VECTOR_DISTANCE U score should be positive for the fixture");}
            }
        }
    }

    private static String env(String name, String fallback) {
        String value = System.getenv(name);
        return value == null || value.isBlank() ? fallback : value;
    }
}
