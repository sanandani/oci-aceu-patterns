package com.example.aceu;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
class SkillVectorTest {
 @Test void fixedVocabularyProducesStableBinaryVector() throws Exception {
  var skills=new ObjectMapper().readTree("[\"sql\",\"cloud\"]");
  assertEquals("[0.0,1.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0]",SkillVector.encode(skills));
 }
}
