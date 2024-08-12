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
