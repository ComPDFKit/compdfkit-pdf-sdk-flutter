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
