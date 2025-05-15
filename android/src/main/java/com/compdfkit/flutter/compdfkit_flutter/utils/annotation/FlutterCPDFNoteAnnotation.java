package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import com.compdfkit.core.annotation.CPDFAnnotation;
import java.util.HashMap;

public class FlutterCPDFNoteAnnotation extends FlutterCPDFBaseAnnotation {


  @Override
  public void covert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    map.put("type", "note");
  }
}
