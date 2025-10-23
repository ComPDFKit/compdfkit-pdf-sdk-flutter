/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

package com.compdfkit.flutter.compdfkit_flutter.constants;


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

    public static final String INIT_SDK_WITH_PATH = "init_sdk_with_path";

    /**
     * Get ComPDFKit SDK Version Code
     * Example: 2.0.0
     */
    public static final String SDK_VERSION_CODE = "sdk_version_code";

    public static final String SDK_BUILD_TAG = "sdk_build_tag";

    public static final String OPEN_DOCUMENT = "open_document";

    public static final String GET_TEMP_DIRECTORY = "get_temporary_directory";
    public static final String REMOVE_SIGN_FILE_LIST = "remove_sign_file_list";

    public static final String PICK_FILE = "pick_file";

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

    public static final String SET_PAGE_SPACING = "set_page_spacing";

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

    public static final String GET_FILE_NAME = "get_file_name";

    public static final String IS_ENCRYPTED = "is_encrypted";

    public static final String IS_IMAGE_DOC = "is_image_doc";

    public static final String GET_PERMISSIONS = "get_permissions";

    public static final String CHECK_OWNER_UNLOCKED = "check_owner_unlocked";

    public static final String CHECK_OWNER_PASSWORD = "check_owner_password";

    public static final String CLOSE = "close";

    public static final String HAS_CHANGE = "has_change";

    public static final String IMPORT_ANNOTATIONS = "import_annotations";

    public static final String EXPORT_ANNOTATIONS = "export_annotations";

    public static final String REMOVE_ALL_ANNOTATIONS = "remove_all_annotations";

    public static final String GET_PAGE_COUNT = "get_page_count";

    public static final String SET_PREVIEW_MODE = "set_preview_mode";

    public static final String GET_PREVIEW_MODE = "get_preview_mode";

    public static final String SHOW_THUMBNAIL_VIEW = "show_thumbnail_view";

    public static final String SHOW_BOTA_VIEW = "show_bota_view";

    public static final String SHOW_ADD_WATERMARK_VIEW = "show_add_watermark_view";

    public static final String SHOW_SECURITY_VIEW = "show_security_view";

    public static final String SHOW_DISPLAY_SETTINGS_VIEW = "show_display_settings_view";

    public static final String ENTER_SNIP_MODE = "enter_snip_mode";

    public static final String EXIT_SNIP_MODE = "exit_snip_mode";

    public static final String SET_SECURITY_INFO = "set_security_info";

    public static final String SAVE_AS = "save_as";

    public static final String PRINT = "print";

    public static final String CREATE_URI = "create_uri";
    public static final String SET_USER_PASSWORD = "set_user_password";
    public static final String REMOVE_PASSWORD = "remove_password";
    public static final String SET_PASSWORD = "set_password";
    public static final String CREATE_WATERMARK = "create_watermark";
    public static final String REMOVE_ALL_WATERMARKS = "remove_all_watermarks";
    public static final String GET_ENCRYPT_ALGORITHM = "get_encrypt_algorithm";
    public static final String SET_IMPORT_FONT_DIRECTORY = "set_import_font_directory";
    public static final String CREATE_DOCUMENT_PLUGIN = "create_document_plugin";
    public static final String IMPORT_WIDGETS = "import_widgets";
    public static final String EXPORT_WIDGETS = "export_widgets";
    public static final String FLATTEN_ALL_PAGES = "flatten_all_pages";
    public static final String IMPORT_DOCUMENT = "import_document";
    public static final String INSERT_BLANK_PAGE = "insert_blank_page";
    public static final String SPLIT_DOCUMENT_PAGES = "split_document_pages";
    public static final String GET_ANNOTATIONS = "get_annotations";
    public static final String GET_WIDGETS = "get_widgets";

    public static final String RELOAD_PAGES = "reload_pages";
    public static final String RELOAD_PAGES_2 = "reload_pages_2";

    public static final String GET_DOCUMENT_PATH = "get_document_path";

    public static final String REMOVE_ANNOTATION = "remove_annotation";
    public static final String REMOVE_WIDGET = "remove_widget";

    public static final String SET_ANNOTATION_MODE = "set_annotation_mode";

    public static final String GET_ANNOTATION_MODE = "get_annotation_mode";
    public static final String ANNOTATION_CAN_UNDO = "annotation_can_undo";
    public static final String ANNOTATION_CAN_REDO = "annotation_can_redo";
    public static final String ANNOTATION_UNDO = "annotation_undo";
    public static final String ANNOTATION_REDO = "annotation_redo";
    public static final String SET_WIDGET_BACKGROUND_COLOR = "set_widget_background_color";

    public static final String SEARCH_TEXT = "search_text";
    public static final String SEARCH_TEXT_SELECTION = "search_text_selection";
    public static final String SEARCH_TEXT_CLEAR = "search_text_clear";
    public static final String GET_SEARCH_TEXT = "get_search_text";
    public static final String CHANGE_EDIT_TYPE = "change_edit_type";
    public static final String CONTENT_EDITOR_CAN_REDO = "content_editor_can_redo";
    public static final String CONTENT_EDITOR_CAN_UNDO = "content_editor_can_undo";
    public static final String CONTENT_EDITOR_REDO = "content_editor_redo";
    public static final String CONTENT_EDITOR_UNDO = "content_editor_undo";
    public static final String SET_FORM_CREATION_MODE = "set_form_creation_mode";
    public static final String GET_FORM_CREATION_MODE = "get_form_creation_mode";
    public static final String VERIFY_DIGITAL_SIGNATURE_STATUS = "verify_digital_signature_status";
    public static final String HIDE_DIGITAL_SIGNATURE_STATUS_VIEW = "hide_digital_sign_status_view";

    public static final String CLEAR_DISPLAY_RECT = "clear_display_rect";
    public static final String DISMISS_CONTEXT_MENU = "dismiss_context_menu";
    public static final String SHOW_TEXT_SEARCH_VIEW = "show_text_search_view";
    public static final String HIDE_TEXT_SEARCH_VIEW = "hide_text_search_view";
    public static final String INSERT_IMAGE_WITH_PATH = "insert_page_with_image_path";
    public static final String GET_PAGE_ROTATION = "get_page_rotation";
    public static final String SET_PAGE_ROTATION = "set_page_rotation";
    public static final String REMOVE_PAGES = "remove_pages";
    public static final String RENDER_PAGE = "render_page";
    public static final String SAVE_CURRENT_INK = "save_current_ink";
  }

}
