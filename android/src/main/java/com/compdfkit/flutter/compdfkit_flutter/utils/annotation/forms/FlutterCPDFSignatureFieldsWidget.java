package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.content.Context;
import android.graphics.Bitmap;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFImageScaleType;
import com.compdfkit.core.annotation.form.CPDFSignatureWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.common.utils.image.CBitmapUtil;
import java.util.HashMap;


public class FlutterCPDFSignatureFieldsWidget extends FlutterCPDFBaseWidget {

  @Override
  public void covert(CPDFWidget widget, HashMap<String, Object> map) {
    CPDFSignatureWidget signatureWidget = (CPDFSignatureWidget) widget;
    map.put("type", "signaturesFields");
  }

  public boolean addImageSignatures(Context context, CPDFAnnotation widget, String imagePath){
    CPDFSignatureWidget signatureWidget = (CPDFSignatureWidget) widget;
    try{
      String path = FileUtils.getImportFilePath(context, imagePath);
      Bitmap bitmap = CBitmapUtil.decodeBitmap(path);
      if (bitmap != null){
        return signatureWidget.updateApWithBitmap(bitmap, CPDFImageScaleType.SCALETYPE_fitCenter);
      }
    }catch (Exception e){
      e.printStackTrace();
      return false;
    }
    return false;
  }
}
