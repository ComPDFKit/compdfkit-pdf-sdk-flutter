/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.utils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import androidx.annotation.ColorInt;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class CAppUtils {

  public static String toHexColor(@ColorInt int color) {
    return "#" + Integer.toHexString(color).toUpperCase();
  }

  public static long toTimes(String time) {
    try {
      SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      Date date = inputFormat.parse(time);
      return date.getTime();
    } catch (ParseException e) {
      return 0L;
    }
  }

  public static double roundTo2(double value) {
    if (Double.isNaN(value) || Double.isInfinite(value)) {
      return value;
    }
    return BigDecimal.valueOf(value)
        .setScale(2, RoundingMode.HALF_UP)
        .doubleValue();
  }

  public static float roundTo2f(float value) {
    if (Float.isNaN(value) || Float.isInfinite(value)) {
      return value;
    }
    return BigDecimal.valueOf(value)
        .setScale(2, RoundingMode.HALF_UP)
        .floatValue();
  }

  public static Bitmap base64ToBitmap(String base64Image) {
    base64Image = base64Image.replaceAll("\\s+", "");
    byte[] decodedBytes = Base64.decode(base64Image, Base64.DEFAULT);
    return BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);
  }

  public static String getDefaultFiledName(String widgetType) {
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    String dateStr = df.format(new Date());
    return String.format("%s%s", widgetType, dateStr);
  }
}
