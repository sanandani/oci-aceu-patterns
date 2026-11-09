package com.example.aceu;
import com.fasterxml.jackson.databind.JsonNode;
import java.util.*;
public final class SkillVector {
    private static final List<String> VOCAB=List.of("java","sql","security","design","mentoring","ml","cloud","writing","testing","governance");
    private SkillVector() {}
    public static String encode(JsonNode skills) {
        double[] v=new double[10]; if(skills!=null && skills.isArray()) for(JsonNode n:skills) { int i=VOCAB.indexOf(n.asText().toLowerCase(Locale.ROOT)); if(i>=0)v[i]=1; }
        StringJoiner j=new StringJoiner(",","[","]"); for(double x:v)j.add(Double.toString(x)); return j.toString();
    }
}
