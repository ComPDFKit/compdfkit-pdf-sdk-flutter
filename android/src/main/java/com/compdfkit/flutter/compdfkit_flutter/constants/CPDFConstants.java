/*
 * Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.constants;


import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public class CPDFConstants {

  public static class ChannelMethod {

    /**
     * Offline SDK authentication method.
     */
    public static final String INIT_SDK = "init_sdk";

    /**
     * Online SDK authentication method.
     */
    public static final String INIT_SDK_KEYS = "init_sdk_keys";

    /**
     * Get ComPDFKit SDK Version Code
     * Example: 2.0.0
     */
    public static final String SDK_VERSION_CODE = "sdk_version_code";

    public static final String SDK_BUILD_TAG = "sdk_build_tag";

    public static final String OPEN_DOCUMENT = "open_document";

    public static final String GET_TEMP_DIRECTORY = "get_temporary_directory";

    public static final String SAVE = "save";

    public static final String SET_SCALE = "set_scale";

    public static final String GET_SCALE = "get_scale";

    public static final String SET_CAN_SCALE = "set_can_scale";

    public static final String SET_READ_BACKGROUND_COLOR = "set_read_background_color";
    public static final String GET_READ_BACKGROUND_COLOR = "get_read_background_color";

    public static final String SET_FORM_FIELD_HIGHLIGHT = "set_form_field_highlight";

    public static final String IS_FORM_FIELD_HIGHLIGHT = "is_form_field_highlight";

    public static final String SET_LINK_HIGHLIGHT = "set_link_highlight";
    public static final String IS_LINK_HIGHLIGHT = "is_link_highlight";

    public static final String SET_VERTICAL_MODE = "set_vertical_mode";

    public static final String IS_VERTICAL_MODE = "is_vertical_mode";

    public static final String SET_MARGIN = "set_margin";

    public static final String SET_CONTINUE_MODE = "set_continue_mode";

    public static final String IS_CONTINUE_MODE = "is_continue_mode";

    public static final String SET_DOUBLE_PAGE_MODE = "set_double_page_mode";

    public static final String IS_DOUBLE_PAGE_MODE = "is_double_page_mode";

    public static final String SET_CROP_MODE = "set_crop_mode";

    public static final String IS_CROP_MODE = "is_crop_mode";

    public static final String SET_DISPLAY_PAGE_INDEX = "set_display_page_index";

    public static final String GET_CURRENT_PAGE_INDEX = "get_current_page_index";

    public static final String SET_PAGE_SAME_WIDTH = "set_page_same_width";

    public static final String IS_PAGE_IN_SCREEN = "is_page_in_screen";

    public static final String SET_FIXED_SCROLL = "set_fixed_scroll";

    public static final String SET_COVER_PAGE_MODE = "set_cover_page_mode";

    public static final String IS_COVER_PAGE_MODE = "is_cover_page_mode";

    public static final String GET_PAGE_SIZE = "get_page_size";

    public static final String HAS_CHANGE = "has_change";

  }

}
