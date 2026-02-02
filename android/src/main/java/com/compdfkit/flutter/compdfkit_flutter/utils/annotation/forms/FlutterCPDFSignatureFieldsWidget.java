package com.compdfkit.flutter.compdfkit_flutter.utils.annotation.forms;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.RectF;
import android.text.TextUtils;
import com.compdfkit.core.annotation.CPDFAnnotation;
import com.compdfkit.core.annotation.CPDFImageScaleType;
import com.compdfkit.core.annotation.form.CPDFCheckboxWidget;
import com.compdfkit.core.annotation.form.CPDFCheckboxWidget.CheckboxStyle;
import com.compdfkit.core.annotation.form.CPDFSignatureWidget;
import com.compdfkit.core.annotation.form.CPDFWidget;
import com.compdfkit.core.annotation.form.CPDFWidget.BorderStyle;
import com.compdfkit.core.annotation.form.CPDFWidget.WidgetType;
import com.compdfkit.core.document.CPDFDocument;
import com.compdfkit.core.page.CPDFPage;
import com.compdfkit.core.utils.TTimeUtil;
import com.compdfkit.flutter.compdfkit_flutter.utils.CAppUtils;
import com.compdfkit.flutter.compdfkit_flutter.utils.FileUtils;
import com.compdfkit.tools.common.utils.image.CBitmapUtil;
import java.util.HashMap;


public class FlutterCPDFSignatureFieldsWidget extends FlutterCPDFBaseWidget {

  @Override
  public void covert(CPDFWidget widget, HashMap<String, Object> map) {
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

  @Override
  public CPDFWidget addWidget(CPDFDocument document, HashMap<String, Object> widgetMap) {
    int pageIndex = (int) widgetMap.get("page");
    String title = widgetMap.get("title").toString();
    HashMap<String, Object> rectMap = (HashMap<String, Object>) widgetMap.get("rect");
    double left = (double) rectMap.get("left");
    double top = (double) rectMap.get("top");
    double right = (double) rectMap.get("right");
    double bottom = (double) rectMap.get("bottom");

    String fillColor = widgetMap.get("fillColor").toString();
    String borderColor = widgetMap.get("borderColor").toString();
    double borderWidth = (double) widgetMap.get("borderWidth");

    CPDFPage page = document.pageAtIndex(pageIndex);
    CPDFSignatureWidget widget = (CPDFSignatureWidget) page.addFormWidget(
        WidgetType.Widget_SignatureFields);
    if (widget.isValid()){
      RectF rectF = new RectF((float) left, (float) top, (float) right, (float) bottom);
      widget.setRect(rectF);
      if (TextUtils.isEmpty(title)){
        widget.setFieldName(CAppUtils.getDefaultFiledName("Signature_"));
      } else {
        widget.setFieldName(title);
      }
      if (widgetMap.get("createDate") != null){
        long createDateTimestamp = (long) widgetMap.get("createDate");
        widget.setCreationDate(TTimeUtil.fromTimestamp(createDateTimestamp));
        widget.setRecentlyModifyDate(TTimeUtil.fromTimestamp(createDateTimestamp));
      } else {
        widget.setCreationDate(TTimeUtil.getCurrentDate());
        widget.setRecentlyModifyDate(TTimeUtil.getCurrentDate());
      }
      widget.setBorderStyles(BorderStyle.BS_Solid);
      widget.setBorderColor(Color.parseColor(borderColor));
      widget.setBorderWidth((float) borderWidth);
      widget.setFillColor(Color.parseColor(fillColor));
      widget.updateAp();
    }
    return widget;
  }
}
