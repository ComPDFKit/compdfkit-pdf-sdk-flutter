// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:convert';

import 'package:compdfkit_flutter/annotation/cpdf_annotation.dart';
import 'package:compdfkit_flutter/annotation/cpdf_link_annotation.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_annotation_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_content_editor_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_config.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_item.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_context_menu_options.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_form_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_global_context_menu.dart';
import 'package:compdfkit_flutter/configuration/contextmenu/cpdf_view_mode_context_menu.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_image_area.dart';
import 'package:compdfkit_flutter/edit/cpdf_edit_text_area.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../utils/preferences_service.dart';
import '../../widgets/example_base.dart';
import '../shared/example_document_loader.dart';

void printJsonString(String jsonString) {
  debugPrint(jsonString);
}

/// Context Menu Customization Example
///
/// Demonstrates how to fully customize context menus that appear when
/// interacting with PDF content, annotations, forms, and content editor areas.
///
/// This example shows:
/// - Customizing global context menus (screenshot actions)
/// - Customizing view mode menus (text selection copy, custom actions)
/// - Customizing annotation mode menus (markup, ink, shape, freeText, stamp, link)
/// - Customizing content editor menus (text areas, image areas, crop mode)
/// - Customizing form mode menus (textField, checkBox, radioButton, listBox, etc.)
/// - Adding custom menu items with icons and identifiers
/// - Handling custom menu item tap events with event data
///
/// Key classes/APIs used:
/// - [CPDFContextMenuConfig]: Root configuration for all context menus
/// - [CPDFGlobalContextMenu]: Global menus like screenshot actions
/// - [CPDFViewModeContextMenu]: Menus for text selection in view mode
/// - [CPDFAnnotationModeContextMenu]: Menus for annotation interactions
/// - [CPDFContentEditorModeContextMenu]: Menus for content editing
/// - [CPDFFormModeContextMenu]: Menus for form field interactions
/// - [CPDFContextMenuItem]: Individual menu item with action, icon, and identifier
/// - [onCustomContextMenuItemTapped]: Callback for handling custom menu actions
///
/// Usage:
/// 1. Create [CPDFContextMenuConfig] with customized menu sections
/// 2. Define [CPDFContextMenuItem] for each menu with appropriate keys
/// 3. Use custom identifiers for items that need special handling
/// 4. Override [onCustomContextMenuItemTapped] to process custom actions
/// 5. Access event data (annotation, widget, editArea, rect, point) as needed
class ContextMenuCustomizationExample extends StatelessWidget {
  /// Constructor
  const ContextMenuCustomizationExample({super.key});

  static const String _assetPath = AppAssets.pdfDocument;

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Context Menu Customization',
      assetPath: _assetPath,
      builder: (path) => _ContextMenuCustomizationPage(documentPath: path),
    );
  }
}

class _ContextMenuCustomizationPage extends ExampleBase {
  const _ContextMenuCustomizationPage({required super.documentPath});

  @override
  State<_ContextMenuCustomizationPage> createState() =>
      _ContextMenuCustomizationPageState();
}

class _ContextMenuCustomizationPageState
    extends ExampleBaseState<_ContextMenuCustomizationPage> {
  @override
  String get pageTitle => 'Context Menu Customization';

  @override
  CPDFConfiguration get configuration => CPDFConfiguration(
        annotationsConfig: CPDFAnnotationsConfig(
          annotationAuthor: PreferencesService.documentAuthor,
        ),
        readerViewConfig: CPDFReaderViewConfig(
          linkHighlight: PreferencesService.highlightLink,
          formFieldHighlight: PreferencesService.highlightForm,
        ),
        contextMenuConfig: const CPDFContextMenuConfig(
          fontSize: 14,
          iconSize: 36,
          padding: [0, 4, 0, 4],
          global: CPDFGlobalContextMenu(
            screenshot: [
              CPDFContextMenuItem(
                CPDFScreenShotMenuKey.exit,
                title: 'Exit',
                showType: CPDFContextMenuShowType.text,
              ),
              CPDFContextMenuItem(
                CPDFScreenShotMenuKey.share,
                showType: CPDFContextMenuShowType.icon,
                title: 'Share',
                icon: 'ic_test_share',
              ),
              CPDFContextMenuItem(
                CPDFScreenShotMenuKey.custom,
                showType: CPDFContextMenuShowType.icon,
                icon: 'ic_test_download',
                identifier: 'custom_screenshot_action',
                title: 'Download',
              ),
            ],
          ),
          viewMode: CPDFViewModeContextMenu(
            textSelect: [
              CPDFContextMenuItem(
                CPDFViewModeTextSelectKey.copy,
                title: 'Copy Text',
                showType: CPDFContextMenuShowType.text,
              ),
              CPDFContextMenuItem(
                CPDFViewModeTextSelectKey.custom,
                title: 'Draw Rect',
                identifier: 'custom_text_select_action',
              ),
            ],
          ),
          annotationMode: CPDFAnnotationModeContextMenu(
            textSelect: [
              CPDFContextMenuItem(
                CPDFAnnotationTextSelectMenuKey.copy,
                icon: 'ic_test_copy',
                showType: CPDFContextMenuShowType.icon,
              ),
              CPDFContextMenuItem(
                CPDFAnnotationTextSelectMenuKey.highlight,
                icon: 'ic_test_highlight',
                showType: CPDFContextMenuShowType.icon,
              ),
              CPDFContextMenuItem(
                CPDFAnnotationTextSelectMenuKey.underline,
                icon: 'ic_test_underline',
                showType: CPDFContextMenuShowType.icon,
              ),
              CPDFContextMenuItem(
                CPDFAnnotationTextSelectMenuKey.strikeout,
                icon: 'ic_test_strikeout',
                showType: CPDFContextMenuShowType.icon,
              ),
              CPDFContextMenuItem(
                CPDFAnnotationTextSelectMenuKey.squiggly,
                icon: 'ic_test_wavyline',
                showType: CPDFContextMenuShowType.icon,
              ),
              CPDFContextMenuItem(
                CPDFAnnotationTextSelectMenuKey.custom,
                icon: 'ic_test_rect',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_annotation_text_select_show_rect',
                title: 'Show Rect',
              ),
            ],
            longPress: [
              CPDFContextMenuItem(CPDFAnnotationLongPressMenuKey.paste),
              CPDFContextMenuItem(
                CPDFAnnotationLongPressMenuKey.custom,
                title: 'Get Point',
                identifier: 'custom_event_get_point',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationLongPressMenuKey.note,
                icon: 'ic_test_note',
                showType: CPDFContextMenuShowType.icon,
              ),
            ],
            markup: [
              CPDFContextMenuItem(
                CPDFAnnotationMarkupMenuKey.custom,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_show_annotation_properties_action',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationMarkupMenuKey.note,
                icon: 'ic_test_note',
                showType: CPDFContextMenuShowType.icon,
              ),
              CPDFContextMenuItem(
                CPDFAnnotationMarkupMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_annotation_delete_action',
                title: 'Delete',
              ),
                                          CPDFContextMenuItem(
                CPDFAnnotationMarkupMenuKey.custom,
                icon: 'ic_test_download',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_render_annotation_appearance',
                title: 'Render Appearance',
              ),
            ],
            sound: [
              CPDFContextMenuItem(
                CPDFAnnotationSoundMenuKey.play,
                icon: 'ic_test_play',
                showType: CPDFContextMenuShowType.icon,
              ),
              CPDFContextMenuItem(
                CPDFAnnotationSoundMenuKey.record,
                icon: 'ic_test_record',
                showType: CPDFContextMenuShowType.icon,
              ),
              CPDFContextMenuItem(
                CPDFAnnotationSoundMenuKey.delete,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
              ),
              CPDFContextMenuItem(
                CPDFAnnotationSoundMenuKey.custom,
                title: 'Get Annotation',
                identifier: 'custom_event_get_sound_annotation',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationSoundMenuKey.custom,
                icon: 'ic_test_download',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_render_annotation_appearance',
                title: 'Render Appearance',
              ),
            ],
            ink: [
              CPDFContextMenuItem(
                CPDFAnnotationInkMenuKey.custom,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_show_annotation_properties_action',
                title: 'Test Properties',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationInkMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_annotation_delete_action',
                title: 'Delete Ink',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationInkMenuKey.custom,
                icon: 'ic_test_download',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_render_annotation_appearance',
                title: 'Render Appearance',
              ),
            ],
            shape: [
              CPDFContextMenuItem(
                CPDFAnnotationShapeMenuKey.custom,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_show_annotation_properties_action',
                title: 'Test Properties',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationShapeMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_annotation_delete_action',
                title: 'Delete Shape',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationShapeMenuKey.custom,
                icon: 'ic_test_download',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_render_annotation_appearance',
                title: 'Render Appearance',
              ),
            ],
            freeText: [
              CPDFContextMenuItem(
                CPDFAnnotationFreeTextMenuKey.custom,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_show_annotation_properties_action',
                title: 'Text Properties',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationFreeTextMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_annotation_delete_action',
                title: 'Delete FreeText',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationFreeTextMenuKey.custom,
                icon: 'ic_test_download',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_render_annotation_appearance',
                title: 'Render Appearance',
              ),
            ],
            signStamp: [
              CPDFContextMenuItem(CPDFAnnotationSignMenuKey.signHere),
              CPDFContextMenuItem(
                CPDFAnnotationSignMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_annotation_delete_action',
                title: 'Delete Signature',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationSignMenuKey.rotate,
                icon: 'ic_test_rotate',
                showType: CPDFContextMenuShowType.icon,
                title: 'Rotate Signature',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationSignMenuKey.custom,
                icon: 'ic_test_download',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_render_annotation_appearance',
                title: 'Render Appearance',
              ),
            ],
            stamp: [
              CPDFContextMenuItem(
                CPDFAnnotationStampMenuKey.note,
                icon: 'ic_test_note',
                showType: CPDFContextMenuShowType.icon,
                title: 'Add Note',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationStampMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_annotation_delete_action',
                title: 'Delete Stamp',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationStampMenuKey.custom,
                icon: 'ic_test_download',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_render_annotation_appearance',
                title: 'Render Appearance',
              ),
            ],
            link: [
              CPDFContextMenuItem(
                CPDFAnnotationLinkMenuKey.edit,
                icon: 'ic_test_edit',
                showType: CPDFContextMenuShowType.icon,
                title: 'Edit Link',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationLinkMenuKey.custom,
                icon: 'ic_test_edit',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_link_annotation_edit_action',
                title: 'Custom Edit Link',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationLinkMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_annotation_delete_action',
                title: 'Delete Link',
              ),
              CPDFContextMenuItem(
                CPDFAnnotationLinkMenuKey.custom,
                icon: 'ic_test_download',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_render_annotation_appearance',
                title: 'Render Appearance',
              ),
            ],
          ),
          contentEditorMode: CPDFContentEditorModeContextMenu(
            editTextArea: [
              CPDFContextMenuItem(
                CPDFContentEditorEditTextAreaMenuKey.properties,
                title: 'Text Properties',
              ),
              CPDFContextMenuItem(CPDFContentEditorEditTextAreaMenuKey.edit),
              CPDFContextMenuItem(CPDFContentEditorEditTextAreaMenuKey.cut),
              CPDFContextMenuItem(CPDFContentEditorEditTextAreaMenuKey.copy),
              CPDFContextMenuItem(CPDFContentEditorEditTextAreaMenuKey.delete),
              CPDFContextMenuItem(
                CPDFContentEditorEditTextAreaMenuKey.custom,
                identifier: 'custom_edit_get_text',
                title: 'Get Text',
              ),
            ],
            editSelectText: [
              CPDFContextMenuItem(
                CPDFContentEditorEditSelectTextMenuKey.properties,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                title: 'Text Properties',
              ),
              CPDFContextMenuItem(
                CPDFContentEditorEditSelectTextMenuKey.opacity,
                subItems: [
                  CPDFContextMenuOpacityKey.opacity25,
                  CPDFContextMenuOpacityKey.opacity50,
                  CPDFContextMenuOpacityKey.opacity75,
                  CPDFContextMenuOpacityKey.opacity100,
                ],
              ),
              CPDFContextMenuItem(
                CPDFContentEditorEditSelectTextMenuKey.custom,
                title: 'Get Text',
                identifier: 'custom_edit_get_text',
              ),
            ],
            imageArea: [
              CPDFContextMenuItem(
                CPDFContentEditorImageAreaMenuKey.custom,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_show_edit_image_properties_action',
                title: 'Image Properties',
              ),
              CPDFContextMenuItem(
                CPDFContentEditorImageAreaMenuKey.crop,
                icon: 'ic_test_crop',
                showType: CPDFContextMenuShowType.icon,
                title: 'Crop Image',
              ),
              CPDFContextMenuItem(
                CPDFContentEditorImageAreaMenuKey.delete,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                title: 'Delete Image',
              ),
            ],
            imageCropMode: [
              CPDFContextMenuItem(
                CPDFContentEditorImageCropMenuKey.done,
                icon: 'ic_test_done',
                showType: CPDFContextMenuShowType.icon,
                title: 'Done',
              ),
              CPDFContextMenuItem(
                CPDFContentEditorImageCropMenuKey.cancel,
                icon: 'ic_test_cancel',
                showType: CPDFContextMenuShowType.icon,
                title: 'Test Cancel',
              ),
            ],
            editPathContent: [
              CPDFContextMenuItem(
                CPDFContentEditorEditPathMenuKey.delete,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                title: 'Delete Path',
              ),
            ],
            longPressWithEditTextMode: [
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithEditTextModeMenuKey.addText,
                icon: 'ic_test_add_text',
                showType: CPDFContextMenuShowType.icon,
                title: 'Add Text',
              ),
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithEditTextModeMenuKey.paste,
              ),
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithEditTextModeMenuKey.keepTextOnly,
              ),
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithEditTextModeMenuKey
                    .keepSourceFormatingPaste,
              ),
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithEditTextModeMenuKey.custom,
                identifier: 'custom_event_get_point',
                title: 'Get Point',
              ),
            ],
            longPressWithEditImageMode: [
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithEditImageModeMenuKey.addImages,
                icon: 'ic_test_add_image',
                showType: CPDFContextMenuShowType.icon,
                title: 'Add Image',
              ),
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithEditImageModeMenuKey.paste,
              ),
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithEditImageModeMenuKey.custom,
                identifier: 'custom_event_get_point',
                title: 'Get Point',
              ),
            ],
            longPressWithAllMode: [
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithAllModeMenuKey.paste,
              ),
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithAllModeMenuKey
                    .keepSourceFormatingPaste,
              ),
              CPDFContextMenuItem(
                CPDFContentEditorLongPressWithAllModeMenuKey.custom,
                identifier: 'custom_event_get_point',
                title: 'Get Point',
              ),
            ],
          ),
          formMode: CPDFFormModeContextMenu(
            textField: [
              CPDFContextMenuItem(
                CPDFFormTextFieldMenuKey.properties,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                title: 'Test Properties',
              ),
              CPDFContextMenuItem(
                CPDFFormTextFieldMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_widget_delete_action',
                title: 'Delete TextField',
              ),
            ],
            checkBox: [
              CPDFContextMenuItem(
                CPDFFormCheckBoxMenuKey.custom,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_widget_show_properties_action',
                title: 'Test Properties',
              ),
              CPDFContextMenuItem(
                CPDFFormCheckBoxMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_widget_delete_action',
                title: 'Delete CheckBox',
              ),
            ],
            radioButton: [
              CPDFContextMenuItem(
                CPDFFormRadioButtonMenuKey.properties,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                title: 'Test Properties',
              ),
              CPDFContextMenuItem(
                CPDFFormRadioButtonMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_widget_delete_action',
                title: 'Delete RadioButton',
              ),
            ],
            listBox: [
              CPDFContextMenuItem(
                CPDFFormListBoxMenuKey.options,
                icon: 'ic_test_edit',
                showType: CPDFContextMenuShowType.icon,
                title: 'Edit Options',
              ),
              CPDFContextMenuItem(
                CPDFFormListBoxMenuKey.properties,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                title: 'Test Properties',
              ),
              CPDFContextMenuItem(
                CPDFFormListBoxMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_widget_delete_action',
                title: 'Delete ListBox',
              ),
            ],
            comboBox: [
              CPDFContextMenuItem(
                CPDFFormComboBoxMenuKey.options,
                icon: 'ic_test_edit',
                showType: CPDFContextMenuShowType.icon,
                title: 'Edit Options',
              ),
              CPDFContextMenuItem(
                CPDFFormComboBoxMenuKey.properties,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                title: 'Test Properties',
              ),
              CPDFContextMenuItem(
                CPDFFormComboBoxMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_widget_delete_action',
                title: 'Delete ComboBox',
              ),
            ],
            signatureField: [
              CPDFContextMenuItem(
                CPDFFormSignatureFieldMenuKey.startToSign,
                icon: 'ic_test_done',
                showType: CPDFContextMenuShowType.icon,
                title: 'Start to Sign',
              ),
              CPDFContextMenuItem(
                CPDFFormSignatureFieldMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_widget_delete_action',
                title: 'Delete SignatureField',
              ),
            ],
            pushButton: [
              CPDFContextMenuItem(
                CPDFFormPushButtonMenuKey.properties,
                icon: 'ic_test_properties',
                showType: CPDFContextMenuShowType.icon,
                title: 'Test Properties',
              ),
              CPDFContextMenuItem(
                CPDFFormPushButtonMenuKey.custom,
                icon: 'ic_test_delete',
                showType: CPDFContextMenuShowType.icon,
                identifier: 'custom_widget_delete_action',
                title: 'Delete PushButton',
              ),
            ],
          ),
        ),
      );

  @override
  void onCustomContextMenuItemTapped(String identifier, dynamic event) async {
    super.onCustomContextMenuItemTapped(identifier, event);
    if (!mounted) {
      return;
    }
    switch (identifier) {
      case 'custom_screenshot_action':
        final imageData = event['image'];
        _showPreviewDialog(imageData);
        break;
      case 'custom_text_select_action':
        // viewMode.textSelect custom action
        // You can get the selected text, rect and pageIndex from event
        final rect = event['rect'];
        int pageIndex = event['pageIndex'];
        await controller?.setDisplayPageIndex(
          pageIndex: pageIndex,
          rectList: [rect],
        );
        break;
      case 'custom_annotation_text_select_show_rect':
        // annotationMode.textSelect custom action
        // You can get the selected text, rect and pageIndex from event
        final rect = event['rect'];
        int pageIndex = event['pageIndex'];
        await controller?.setDisplayPageIndex(
          pageIndex: pageIndex,
          rectList: [rect],
        );
        break;
      case 'custom_event_get_point':
        final point = event['point'];
        final pageIndex = event['pageIndex'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Long Press Point: $point on Page: $pageIndex'),
          ),
        );
        break;
      case 'custom_annotation_delete_action':
        _removeAnnotation(event);
        break;
      case 'custom_show_annotation_properties_action':
        final annotation = event['annotation'];
        if (annotation is CPDFAnnotation) {
          await controller?.showAnnotationPropertiesView(annotation);
        }
        break;
      case 'custom_event_get_sound_annotation':
        final soundAnnotation = event['annotation'];
        printJsonString(jsonEncode(soundAnnotation));
        break;
      case 'custom_link_annotation_edit_action':
        final annotation = event['annotation'];
        if (annotation is CPDFLinkAnnotation) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Custom Event to Edit Link Annotation: ${annotation.action?.actionType}',
              ),
            ),
          );
        }
        break;
      case 'custom_edit_get_text':
        final textEditArea = event['editArea'];
        if (textEditArea is CPDFEditTextArea) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(textEditArea.text)));
        }
        break;
      case 'custom_get_image':
        final imageEditArea = event['editArea'];
        if (imageEditArea is CPDFEditImageArea) {
          if (imageEditArea.image != null) {
            _showPreviewDialog(imageEditArea.image);
          }
        }
        break;
      case 'custom_show_edit_image_properties_action':
        final imageEditArea = event['editArea'];
        if (imageEditArea != null) {
          await controller?.showEditAreaPropertiesView(imageEditArea);
        }
        break;
      case 'custom_widget_delete_action':
        final widget = event['widget'];
        if (widget is CPDFWidget) {
          await controller?.document.removeWidget(widget);
        }
        break;
      case 'custom_widget_show_properties_action':
        final widget = event['widget'];
        if (widget is CPDFWidget) {
          await controller?.showWidgetPropertiesView(widget);
        }
        break;
      case 'custom_render_annotation_appearance':
        final annotation = event['annotation'];

          try {
            final imageData = await controller?.document.renderAnnotationAppearance(
              annotation,
              options: const CPDFAnnotationRenderOptions(
                compression: CPDFPageCompression.png,
                quality: 100,
              ),
            );
            if (!mounted || imageData == null) {
              return;
            }
            _showPreviewDialog(imageData);
          } catch (e) {
            if (!mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to render annotation appearance: $e'),
              ),
            );
          }
        
        break;  
      default:
        break;
    }
  }

  void _removeAnnotation(dynamic event) async {
    final annotation = event['annotation'];
    if (annotation is CPDFAnnotation) {
      bool? result = await controller?.document.removeAnnotation(annotation);
      if (result == true) {
        debugPrint('ComPDFKit-Flutter: Annotation deleted successfully.');
      }
    }
  }

  void _showPreviewDialog(dynamic image) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Image Preview'),
          content: Image.memory(image, fit: BoxFit.contain),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
