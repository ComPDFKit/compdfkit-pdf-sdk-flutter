## 2.5.0
1. Upgraded iOS ComPDFKit PDF SDK to 2.5.0.
2. Upgraded Android ComPDFKit PDF SDK to 2.5.0.
3. Modify the SDK initialization interface to return the initialization result.
4. Added Spanish language support.
5. Added API to render PDF pages as images.
6. Added API for creating forms.
7. Added watermark configuration options.
8. Added configurable border color for search results.
9. Added configurable highlight color for search results.
10. Added rectangle drawing when jumping to a page.
11. Added API to set content editing types.
12. Added configuration for page editing menu options.
13. Added UI mode configuration.
14. Added bottom toolbar UI configuration.
15. Added BOTA interface configuration.
16. Added control for showing and hiding the search view.
17. Added API to save ongoing Ink annotations.
18. Added API to hide the context menu.
19. Added theme mode configuration on iOS.
20. Added signature method configuration on iOS.
21. Added Pencil annotation toolbar configuration on iOS Issues Addressed.
22. Fixed crash on Android caused by empty arrays in shape annotation properties.
23. Fixed issue where FreeText input was not properly centered on Android.
24. Fixed inconsistency between FreeText font size and the configured value on Android.
25. Fixed issue where imported FreeText annotations might not display on iOS.
26. Fixed issue where the watermark toolbar would not appear when the top toolbar was hidden on iOS.


## 2.5.0-dev.1
1. Upgraded iOS ComPDFKit PDF SDK to 2.5.0-snapshot.
2. Upgraded Android ComPDFKit PDF SDK to 2.5.0.
3. Modify the SDK initialization interface to return the initialization result.
4. Added API to render PDF pages as images.
5. Added API for creating forms.
6. Added watermark configuration options.
7. Added configurable border color for search results.
8. Added configurable highlight color for search results.
9. Added rectangle drawing when jumping to a page.
10. Added API to set content editing types.
11. Added configuration for page editing menu options.
12. Added UI mode configuration.
13. Added bottom toolbar UI configuration.
14. Added BOTA interface configuration.
15. Added control for showing and hiding the search view.
16. Added API to save ongoing Ink annotations.
17. Added API to hide the context menu.
18. Added theme mode configuration on iOS.
19. Added signature method configuration on iOS.
20. Added Pencil annotation toolbar configuration on iOS Issues Addressed.
21. Fixed crash on Android caused by empty arrays in shape annotation properties.
22. Fixed issue where FreeText input was not properly centered on Android.
23. Fixed inconsistency between FreeText font size and the configured value on Android.
24. Fixed issue where imported FreeText annotations might not display on iOS.
25. Fixed issue where the watermark toolbar would not appear when the top toolbar was hidden on iOS.


## 2.4.7
1. Added the features support for ComPDFKit PDF SDK for iOS V2.4.7.
2. Added the features support for ComPDFKit PDF SDK for Android V2.4.7.
3. Automatically hide the quick scroll bar when the document contains only one page
4. Fixed an OOM crash issue caused by importing fonts on the Android platform
5. Fixed a display issue with circle annotations when opacity was set to 0 on the Android platform
6. Fixed a potential crash when modifying properties of circle and line annotations on the Android platform
7. Fixed an issue where some documents failed to correctly trigger callbacks for the first or last page


## 2.4.6
1. Added the features support for ComPDFKit PDF SDK for iOS V2.4.6.
2. Added the features support for ComPDFKit PDF SDK for Android V2.4.6.
3. Added compatibility for Android 15 and Android 16.
4. Optimized page layout and zoom logic for an improved reading experience.
5. Added pinch-to-zoom and page dragging while drawing annotations.
6. Added support for filling out forms in annotation mode on Android.
7. Introduced a new API for text search.
8. Optimized the bottom toolbar UI in signature mode on iOS.
9. Added JSON configuration to enable/disable error prompts and adjusted the display logic for scan document prompts on iOS.
10. Added JSON configuration to enable/disable Ink drawing drag and mode-switch buttons.
11. Fixed a crash caused by entering Emoji characters on Android.
12. Resolved crashes when verifying digital signatures in certain documents on Android.
13. Fixed an issue where adding digital signatures failed in some documents on Android.
14. Fixed an issue where pages always aligned to the left after setting horizontal margins on Android.
15. Fixed page jumping issues in vertical scrolling mode when horizontal margins were set on Android.
16. Fixed an issue where FreeText annotations did not fully display after being saved on Android.
17. Resolved a crash caused by `InitOutFont` during SDK initialization on Android.
18. Fixed an issue where `save()` did not save ongoing Ink and Pencil annotations on iOS.
19. Fixed an issue where the top text was not vertically centered on iOS.
20. Fixed flickering when opening a document multiple times on iOS.
21. Fixed lagging when scrolling in content editing mode on iOS.

## 2.4.5+2
1. Added support for filling out forms in annotation mode on Android.
2. Fixed an issue where the toolbar would reappear after setting mainToolbarVisible=false on Android.
3. Fixed an issue where FreeText annotations were not fully displayed after text input was completed.


## 2.4.5+1
1. Fixed the issue that calling the save() function did not save the text field form being edited.

## 2.4.5
1. Added the features support for ComPDFKit PDF SDK for iOS V2.4.5.
2. Added the features support for ComPDFKit PDF SDK for Android V2.4.5.
3. Fixed the issue where the PDF page was not rendered in some scenarios after calling the save() method.
4. Unified setting of background color of blank area in theme.
5. Added API for setting component background color.

## 2.4.4
1. Added the features support for ComPDFKit PDF SDK for iOS V2.4.4.
2. Added the features support for ComPDFKit PDF SDK for Android V2.4.4.
3. Added configuration option to disable page editing in the thumbnail list.
4. Added support for customizing the background color of the thumbnail list.
5. Added iOS configuration to disable the save prompt on exit.
6. Fixed incorrect default color value for global annotation properties.


## 2.4.3
1. Added the features support for ComPDFKit PDF SDK for iOS V2.4.3.
2. Added the features support for ComPDFKit PDF SDK for Android V2.4.3.
3. Fixed a crash issue when exporting annotation files in certain documents
4. Fixed an issue where selecting an annotation would unexpectedly switch the current drawing annotation type
5. Fixed an issue where deleted text content in some documents was not saved properly
6. Optimized the flickering issue when jumping to a specific page
7. Improved the page navigation logic during annotation undo and redo operations


## 2.4.1

1. Added the features support for ComPDFKit PDF SDK for iOS V2.4.1.  
2. Added the features support for ComPDFKit PDF SDK for Android V2.4.1.
3. Added API to switch between different annotation types in annotation mode.
4. Added Undo and Redo APIs for annotation actions.
5. Added configuration option to hide the bottom annotation toolbar in annotation mode.
6. Added support for context menu configuration.
7. Introduced `CPDFReaderSliderBar`, a sidebar component for fast scrolling.
8. Added callback for tapping on the PDF page area.
9. Adapted Android platform to support 16KB page sizes.
10. Optimized document saving logic on iOS.
11. Fixed an issue where some APIs became unresponsive, causing blocking behavior.
12. Fixed a bug where `CPDFDocument` was not immediately available after creating `CPDFReaderWidgetController`.
13. Fixed an issue where the read-only (`readOnly`) setting had no effect on Android.
14. Fixed a bug where the `page.removeAnnotation()` API could not delete annotations on Android.
15. Fixed an issue where `getReadBackgroundColor()` returned the wrong color on iOS.



## 2.4.0+1

1. Fixed the issue of `flattenAllPages()` not working.
## 2.4.0

1. Added the features support for ComPDFKit PDF SDK for iOS V2.4.0.  
2. Added the features support for ComPDFKit PDF SDK for Android V2.4.0.
3. Added configuration options for signature methods in signature form fields on Android.
4. Added a document save reminder when exiting the interface on Android.  
5. Added functionality to erase existing Ink annotations on Android.  
6. Added APIs to retrieve annotation and form field data.  
7. Added APIs to delete annotations and form fields.  
8. Added an API to insert blank pages.  
9. Added an API to split documents.  
10. Added APIs to import and export XFDF form files.  
11. Added an API to insert PDF documents.  
12. Added an API to flatten documents.  
13. Added configuration option for watermark dialog background color.  
14. Added callback notification when exiting the page editing dialog.  
15. Added callback notification when entering full-screen mode by tapping a page.  
16. Added callback notification for tapping the 'back' button on the toolbar on iOS.
17. Fixed OOM crash issues on some devices during SDK initialization.
18. Fixed an issue where signature appearance was not correctly displayed after digital signing.
19. Fixed an issue where images failed to display after adding a watermark to certain documents.
20. Fixed an issue that prevented inserting PNG images when inserting pages.
21. Fixed incorrect handling of `ActionType_GoToR` and `ActionType_Launch` in hyperlink annotations.
22. Fixed an issue where long input in electronic signatures within `ComPDFKit_Tools` caused incomplete display after saving.
23. Fixed blurry display issue after zooming in on text annotations.
24. Fixed jump behavior of `CPDFReaderView.setScale() `scaling method.
25. Fixed a font inconsistency issue during content editing when adding text to already selected text with an existing device font.



## 2.3.0

* Added the features support for ComPDFKit PDF SDK for iOS iOS V2.3.0.
* Added the features support for ComPDFKit PDF SDK for Android Android V2.3.0.
* Added the ability to create text input fields and insert images by clicking on a page area in content editing mode. 
* Fixed a crash issue when editing or deleting text in certain documents. 
* Fixed the border display issue after completing a free text annotation. 
* Fixed an issue where the LaBan Key input method could not delete the last character while editing text. 
* Fixed text garbling issues in content editing mode. 
* Fixed an issue where form field content was not displayed in some documents. 
* Fixed the issue that the zoomed-in page area did not follow the zooming when jumping to draw a rectangular area. 
* Fixed the issue of Chinese garbled characters in the form name.
* Fixed the issue where the prompt did not appear for scanned PDF documents on iOS.

## 2.2.3
* Fixed the issue where `R.color.tools_pdf_view_ctrl_background_color` resource could not be found during Android build.

## 2.2.2
* Added the features support for ComPDFKit PDF SDK for iOS iOS V2.2.2.
* Added the features support for ComPDFKit PDF SDK for Android Android V2.2.2.
* `CPDFDocument()` can now be used independently, without relying on `CPDFReaderWidget`, enhancing flexibility and ease of use.
* Added the ability to save a watermark to the current PDF when adding it.
* Fixed the inaccurate judgment issue in the `hasChange()` method.
* Fixed an issue where some document text fields in forms were not displaying content.
* Fixed an issue on the Android platform where Ink annotations became smaller after drawing.
* Fixed an issue on the Android platform where the pen size shrank when drawing Ink annotations after zooming in on a page.
* Fixed an input issue with the **LaBan Key** input method on the Android platform.
* Fixed a potential crash issue on the Android platform when enabling the rotate function. 
* Fixed a crash issue on the Android platform when importing XFDF annotations. 
* Fixed an issue on the Android platform where annotations did not appear when printing with `document.printDocument()`. 
* Fixed an issue on Android where the `saveAs()` method resulted in a “document cannot be edited” prompt after saving.


## 2.2.1
* Added the features support for ComPDFKit PDF SDK for iOS [iOS V2.2.1](https://www.compdf.com/pdf-sdk/changelog-ios#v2-2-1).
* Added the features support for ComPDFKit PDF SDK for Android [Android V2.2.1](https://www.compdf.com/pdf-sdk/changelog-android#v2-2-1).
* Added API for importing fonts.
* Added API for adding watermarks.
* Added API for security settings.
* Added view-related APIs, including opening thumbnail lists, preview settings, watermark editing, and security settings.
* Fixed an issue where certain documents could crash when importing XFDF annotations.
* Fixed an issue on iOS where the author information for Ink annotations was not displayed.
* Fixed a crash in iOS 18 when editing content in the context menu.
* Fixed a crash on certain Android devices when initializing the SDK.
* Fixed a crash on Android related to screenshot functionality.
* Optimize the screenshot function of the Android platform to improve the quality of image capture
* Fixed an issue on Android with the LaBan Key input method.
* Fixed an issue on Android where the modified date was not updated when saving a modified document.
* Fixed a crash on Android related to the undo operation in content editing.
* Fixed an issue on Android where form background color was transparent when highlighting forms was not enabled.
* Fixed an issue on Android where annotation text would display incorrectly when editing text in highlighted comment areas.
* Fixed an issue on Android where cloud comment borders were displayed incorrectly in graphic annotations. 
For detailed information about the new interfaces, please refer to `cpdf_reader_widget_controller.dart` and `cpdf_document.dart`.


## 2.2.0
* Added the features support for ComPDFKit PDF SDK for iOS [iOS V2.2.0](https://www.compdf.com/pdf-sdk/changelog-ios#v2-2-0).
* Added the features support for ComPDFKit PDF SDK for Android  [Android V2.2.0](https://www.compdf.com/pdf-sdk/changelog-android#v2-2-0).
* Added import and export annotation interfaces.
* Added delete all annotations interface.
* Added get page number interface and page number listener callback.
* Added save document callback.
* For more details on the newly added APIs, please refer to `cpdf_reader_widget_controller.dart` and `cpdf_document.dart`.

## 2.1.3
* Added the features support for ComPDFKit PDF SDK for iOS V2.1.3.
* Added the features support for ComPDFKit PDF SDK for Android V2.1.3.
* Android:
  * Fixed crash issue when opening certain documents.
  * Fixed crash issue when adding mark annotations to some documents.
  * Fixed potential crash during SDK initialization.
  * Fixed incomplete display of underline annotations.
  * Fixed abnormal annotation display after rotating the page.
  * Fixed crash when releasing watermarks.
  * Fixed memory leak in the property window of the ComPDFKit_Tools module.
* iOS:
  * iOS annotation toolbar image button adaptation for iPad.
  * RN iOS sandbox structure modification.

## 2.1.2

* Added the features support for ComPDFKit PDF SDK for iOS V2.1.2.
* Added the features support for ComPDFKit PDF SDK for Android V2.1.2.
* Optimize document opening speed.

## 2.1.1

* Added the features support for ComPDFKit PDF SDK for iOS V2.1.1.
* Added the features support for ComPDFKit PDF SDK for Android V2.1.1.
* Optimized the logic for selecting text by long press.
* Fixed low text contrast issue in dark mode for some documents.
* Fixed crash issues with some documents.

## 2.1.0

* Added the features support for ComPDFKit PDF SDK for iOS V2.1.0.
* Added the features support for ComPDFKit PDF SDK for Android V2.1.0.
* Added annotation reply functionality.
* Optimized text aggregation logic for content editing.
* Added font subsetting.
* Added screenshot feature.
* Android platform adaptation for **Laban Key Keyboard**.
* Fixed an issue with the Ink annotation color display on Android.
* `CPDFReaderWidgetController.dart` adds widget control methods.


## 2.0.2
* Added `CPDFReaderWidget` widget.
```dart
Scaffold(
  resizeToAvoidBottomInset: false,
  appBar: AppBar(),
  body: CPDFReaderWidget(
    document: documentPath,
    configuration: CPDFConfiguration(),
    onCreated: (controller) {},
  ));
```

## 2.0.1

* Added the features support for ComPDFKit PDF SDK for iOS V2.0.1.
* Added the features support for ComPDFKit PDF SDK for Android V2.0.1.
* Fix the issue of continuous memory growth.


## 2.0.0
* Added the features support for ComPDFKit PDF SDK for iOS V2.0.0.
* Added the features support for ComPDFKit PDF SDK for Android V2.0.0.

## 1.13.0

* Added the features support for ComPDFKit PDF SDK for iOS V1.13.0.
* Added the features support for ComPDFKit PDF SDK for Android V1.13.0.
* Added support for online license verification function.
* Added `ComPDFKit.initialize(androidOnlineLicense : String, iosOnlineLicense : String)` method.
* Added Android platform support for back button configuration in the configuration function
```dart
var configuration = CPDFConfiguration(
        toolbarConfig: const ToolbarConfig(androidAvailableActions: [
          ToolbarAction.back
        ]),);
```

* Added setting page equal width configuration in the configuration function
```dart
var configuration = CPDFConfiguration(
        readerViewConfig: const ReaderViewConfig(pageSameWidth: true));
```


## 1.13.0-dev.2

* Added Android platform support for back button configuration in the configuration function

```dart
var configuration = CPDFConfiguration(
        toolbarConfig: const ToolbarConfig(androidAvailableActions: [
          ToolbarAction.back
        ]),);
```

* Added setting page equal width configuration in the configuration function

```dart
var configuration = CPDFConfiguration(
        readerViewConfig: const ReaderViewConfig(pageSameWidth: true));
```

## 1.13.0-dev.1

* Added the features support for ComPDFKit PDF SDK for iOS V1.13.0-beta.
* Added the features support for ComPDFKit PDF SDK for Android V1.13.0-SNAPSHOT.
* Deprecated ~~`ComPDFKit.init`~~ method, please use `ComPDFKit.initialize(String key, {bool offline})` method.

## 1.12.0

* Added the features support for ComPDFKit PDF SDK for iOS V1.12.0.
* Added the features support for ComPDFKit PDF SDK for Android V1.12.0.
* Added support for finding and replacing text in content editor mode, allowing to set ignore case, whole words only, and replace all.
* Added UI configuration functionality.
* Added support for setting text properties when adding text in content editor mode.
* Added Flatten functionality.

## 1.11.1-dev.1

* Added mode list configuration options.
* Added `CPreviewMode.viewer` mode to view note annotation content

## 1.11.0

* Added the features support for ComPDFKit PDF SDK for Android V1.11.0.
* Added the features support for ComPDFKit PDF SDK for iOS V1.11.0.
* Added the features of adding and deleting watermarks from one or a batch of PDF files.
* Added support for encryption, decryption, and permission settings.
* Added support for digital signatures: Create, sign with, and verify digital certificates and digital signatures.
* Added the feature configuration options.

## 1.0.0

* Added `openDocument` method
* ComPDFKit SDK for Android V1.9.1
* ComPDFKit SDK for IOS V1.9.1
