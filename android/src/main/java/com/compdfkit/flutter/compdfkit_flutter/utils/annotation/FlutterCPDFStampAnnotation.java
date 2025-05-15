package com.compdfkit.flutter.compdfkit_flutter.utils.annotation;


import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFStampAnnotation;
import java.util.HashMap;

public class FlutterCPDFStampAnnotation extends FlutterCPDFBaseAnnotation {

  @Override
  public void covert(CPDFAnnotation annotation, HashMap<String, Object> map) {
    CPDFStampAnnotation stampAnnotation = (CPDFStampAnnotation) annotation;
    if (stampAnnotation.isStampSignature()) {
      map.put("type", "signature");
    } else {
      switch (stampAnnotation.getStampType()) {
        case STANDARD_STAMP:
        case TEXT_STAMP:
          map.put("type", "stamp");
          break;
        case IMAGE_STAMP:
          map.put("type", "pictures");
          break;
      }
    }
  }
}
