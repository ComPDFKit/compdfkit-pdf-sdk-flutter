# ComPDF SDK for Flutter

As part of the KDAN ecosystem, [ComPDF SDK for Flutter](https://www.compdf.com/flutter?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter) helps developers integrate PDF viewing, annotation, editing, form, and signing capabilities into cross-platform mobile apps.

It provides a production-ready Flutter wrapper around native ComPDF SDK capabilities for both Android and iOS projects.

[ComPDF SDK](https://www.compdf.com/?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter) seamlessly operates on [Web](https://www.compdf.com/web?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter), [Windows](https://www.compdf.com/windows?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter), [Android](https://www.compdf.com/android?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter), [iOS](https://www.compdf.com/ios?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter), [Mac](https://www.compdf.com/contact-sales?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter), and [Server](https://www.compdf.com/server?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter), with support for cross-platform frameworks such as [React Native](https://www.compdf.com/react-native?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter), [Flutter](https://www.compdf.com/flutter?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter), etc.



If you find ComPDF SDK useful, please consider giving us a ⭐ **Star** on GitHub — it helps us grow and improve! Got questions or ideas? Join the conversation in our [Discussions](https://github.com/ComPDFKit/compdfkit-pdf-sdk-flutter/discussions).

![UI-1](./screenshots/UI-1.png)

---

**Why ComPDF SDK for Flutter?**

* **Easy to Integrate:** Integrate PDF functionalities easily with our powerful SDK and clear documentation and guides with few lines of code.

* **Fully Customizable UI:** Design a unique interface for your products with fully customizable UI source code by a high-performing SDK.

* **[Comprehensive PDF Features:](https://www.compdf.com/pdf-sdk/features-list?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter)** Supports generation, viewing, annotation, page editing, content editing, conversion, OCR, redaction, signing, forms, parsing, measurement, compression, comparison, color separation, batch processing, and more.

* **Faster Time-to-Market:** Comprehensive SDK libraries save your time and expenses and roll out your applications and projects.

* **High-quality Service:** We provide 24/7 professional one-to-one technical support, including onsite service and remote assistance via phone and email.

---

## Table of Contents

- [Related](#related)
- [Requirements](#requirements)
- [How to Build the Flutter PDF Editor](#how-to-build-the-flutter-pdf-editor)
- [Apply the License Key](#apply-the-license-key)
- [Run Project](#run-project)
- [Example App](#example-app)
- [Changelog](#changelog)
- [Free Trial & License](#free-trial)
- [Support](#support)

---

## Related

- [ComPDF SDK for Flutter Guides](https://www.compdf.com/guides/pdf-sdk/flutter/overview?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter)
- [ComPDF SDK for React Native](https://github.com/ComPDFKit/compdfkit-pdf-sdk-react-native)
- [ComPDF SDK for iOS](https://github.com/ComPDFKit/compdfkit-pdf-sdk-ios-swift)
- [ComPDF SDK for Android](https://github.com/ComPDFKit/compdfkit-pdf-sdk-android)
- [Flutter Package on pub.dev](https://pub.dev/packages/compdfkit_flutter)

---

## Requirements

Before starting, please make sure that you have already met the following prerequisites:

### Get ComPDF License Key

ComPDF offers two types of license keys: a free 30-day trial license and a commercial license.

- **Trial License** – You can request a [30-day free trial](https://www.compdf.com/pricing?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter) online.
- **Commercial License** – For advanced features, custom requirements, or quote inquiries, feel free to [contact our sales](https://www.compdf.com/contact-sales?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter).

For the Flutter PDF SDK, the commercial license must be bound to your application’s ApplicationId and iOS BundleId.

### System Requirements

**Android**

Please install the following required packages:

* The [latest stable version of Flutter](https://docs.flutter.dev/get-started/install)
* The [latest stable version of Android Studio](https://developer.android.com/studio)
* The [Android NDK](https://developer.android.com/studio/projects/install-ndk)
* An [Android Virtual Device](https://developer.android.com/studio/run/managing-avds.html)

Operating Environment Requirements:

* A minSdkVersion of `21` or higher.
* A `compileSdkVersion` of `34` or higher.
* A `targetSdkVersion` of `34` or higher.
* Android ABI(s): x86, x86_64, armeabi-v7a, arm64-v8a.

**iOS**

Please install the following required packages:

* The [latest stable version of Flutter](https://docs.flutter.dev/get-started/install)
* The [latest stable version of Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
* The [latest stable version of CocoaPods](https://github.com/CocoaPods/CocoaPods/releases). Follow the [CocoaPods installation guide](https://guides.cocoapods.org/using/getting-started.html#installation) to install it.

Operating Environment Requirements:

* The iOS 12.0 or higher.
* The Xcode 12.0 or newer for Objective-C or Swift.

---

## How to Build the Flutter PDF Editor

[![image](https://img.youtube.com/vi/I0Rz11iVAbE/maxresdefault.jpg)](https://youtu.be/I0Rz11iVAbE)

### Create a new project

#### Android

1. Create a Flutter project called `example` with the `flutter` CLI:

```bash
flutter create --org com.compdfkit.flutter example
```

2. In the terminal app, change the location of the current working directory to your project:

```bash
cd example
```

3. open  `example/android/app/src/main/AndroidManifest.xml` , add `Internet Permission` and `Storage Permission`:

```diff
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.compdfkit.flutter.example">

+    <uses-permission android:name="android.permission.INTERNET"/>

    <!-- Required to read and write documents from device storage -->
+    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
+    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

    <!-- Optional settings -->
+    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>


    <application
+      android:requestLegacyExternalStorage="true">

    </application>   
</manifest>
```

4. Open the app's Gradle build file, `android/app/build.gradle`:

```bash
open android/app/build.gradle
```

5. Modify the minimum SDK version, All this is done inside the `android` section:

```diff
 android {
     defaultConfig {
-        minSdkVersion flutter.minSdkVersion
+        minSdkVersion 21
         ...
     }
 }
```

6. Open the project’s main activity class, `android/app/src/main/java/com/example/compdfkit/flutter/example/MainActivity.java`, Change the base `Activity` to extend `FlutterFragmentActivity`:

```diff
- import io.flutter.embedding.android.FlutterActivity;
+ import io.flutter.embedding.android.FlutterFragmentActivity;

- public class MainActivity extends FlutterActivity {
+ public class MainActivity extends FlutterFragmentActivity {
}
```

Alternatively you can update the `AndroidManifest.xml` file to use `FlutterFragmentActivity` as the launcher activity:

```diff
<activity
-     android:name=".MainActivity" 
+     android:name="io.flutter.embedding.android.FlutterFragmentActivity"
      android:exported="true"
      android:hardwareAccelerated="true"
      android:launchMode="singleTop"
      android:theme="@style/LaunchTheme"
      android:windowSoftInputMode="adjustPan">
```

> **Note:** `FlutterFragmentActivity` is not an official part of the Flutter SDK. If you need to use `CPDFReaderWidget` in ComPDF for Flutter, you need to use this part of the code. You can skip this step if you don't need to use.

7. Add the ComPDF dependency in `pubspec.yaml`

```diff
 dependencies:
   flutter:
     sdk: flutter
+  compdfkit_flutter: ^2.6.6
```

8. Add the PDF documents you want to display in the project

* create a `pdf` directory

  ```bash
  mkdir pdfs
  ```

* Copy your example document into the newly created `pdfs` directory and name it `PDF_Document.pdf`

9. Specify the `assets` directory in `pubspec.yaml`

```diff
 flutter:
+  assets:
+    - pdfs/
```

10. From the terminal app, run the following command to get all the packages:

```bash
flutter pub get
```

#### iOS

1. Create a Flutter project called `example` with the `flutter` CLI:

```bash
flutter create --org com.compdfkit.flutter example
```

2. In the terminal app, change the location of the current working directory to your project:

```bash
cd example
```

3. Add the ComPDF dependency in `pubspec.yaml`

```diff
 dependencies:
   flutter:
     sdk: flutter
+  compdfkit_flutter: ^2.6.6
```

4. Open your project's Podfile in a text editor:

```bash
open ios/Podfile
```

**Note:** If SSL network requests fail to download the `ComPDFKit` library when you run `pod install`, you can see the processing method in [Troubleshooting](#Troubleshooting)).

6. Update the platform to iOS 12 and add the ComPDF Podspec:

```diff
- platform :ios, '9.0'
+ platform :ios, '12.0' 
 ...
 target 'Runner' do
   use_frameworks!
   use_modular_headers!`

   flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
+  pod 'ComPDFKit', :git => 'https://github.com/ComPDFKit/compdfkit-pdf-sdk-ios-swift.git', :tag => '2.6.6'
+  pod 'ComPDFKit_Tools', :git => 'https://github.com/ComPDFKit/compdfkit-pdf-sdk-ios-swift.git', :tag => '2.6.6'
 end
```

7. Go to the `example/ios` folder and run the `pod install` command:

```bash
pod install
```

8. Add the PDF documents you want to display in the project

* create a `pdf` directory

  ```bash
  mkdir pdfs
  ```

* Copy your example document into the newly created `pdfs` directory and name it `PDF_Document.pdf`

9. Specify the `assets` directory in `pubspec.yaml`

```diff
 flutter:
+  assets:
+    - pdfs/
```

10. To protect user privacy, before accessing the sensitive privacy data, you need to find the "***Info\***" configuration in your iOS 10.0 or higher iOS project and configure the relevant privacy terms as shown in the following picture.

![1-8](./screenshots/1-8.png)

```objective-c
<key>NSCameraUsageDescription</key>
<string>Your consent is required before you could access the function.</string>

<key>NSMicrophoneUsageDescription</key>
<string>Your consent is required before you could access the function.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Your consent is required before you could access the function.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Your consent is required before you could access the function.</string>

<key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
```

11. From the terminal app, run the following command to get all the packages:

```bash
flutter pub get
```

### Apply the License Key

ComPDF SDK currently supports two authentication methods to verify license keys: online authentication and offline authentication.

Learn about:

* [What is the authentication mechanism of ComPDF](https://www.compdf.com/faq/authentication-mechanism-of-compdfkit-license?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter)
* [What are the differences between Online Authentication and Offline Authentication?](https://www.compdf.com/faq/the-differences-between-online-authentication-and-offline-authentication?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter)

Accurately obtaining the license key is crucial for the application of the license.

1. In the email you received, locate the `XML` file containing the license key.
2. Copy the License.xml file into the **assets directory** of your Flutter project.

![3_1](./screenshots/guides_flutter_2.3_1.png)

3. Open the pubspec.yaml file of your project and configure the flutter: section to enable the assets directory.

![3_2](./screenshots/guides_flutter_2.3_2.png)

4. Initialize the SDK:

```dart
// Include the license in Flutter assets and copy to device storage
// Add `license_key_flutter.xml` to your Flutter project’s assets directory;
File licenseFile = await CPDFFileUtil.extractAsset(context, 'assets/license_key_flutter.xml');
ComPDFKit.initWithPath(licenseFile.path);
```

**Alternative methods (optional)**

```dart
// Android
// Copy the license_key_flutter.xml file into the `android/app/src/main/assets` directory of your Android project:
ComPDFKit.initWithPath('assets://license_key_flutter.xml');

// iOS
// Copy the license_key_flutter.xml file into your iOS project directory (or a readable location):
ComPDFKit.initWithPath('license_key_flutter.xml');
```

### Run Project

There are 2 different ways to use ComPDF Flutter API:

* Present a document via a plugin.
* Show a ComPDF document view via a Widget.

#### Usage Plugin

Open `lib/main.dart`,replace the entire file with the following:

```dart
import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:flutter/material.dart';

const String _documentPath = 'pdfs/PDF_Document.pdf';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    File licenseFile = await CPDFFileUtil.extractAsset(context, 'assets/license_key_flutter.xml');
    ComPDFKit.initWithPath(licenseFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: ElevatedButton(
              onPressed: () async {
                showDocument(context);
              },
              child: const Text(
                'Open Document',
              )),
          ))),
    );
  }

  void showDocument(BuildContext context) async {
    var pdfFile = await CPDFFileUtil.extractAsset(_documentPath);
    var configuration = CPDFConfiguration();
    // Present a document via a plugin.
    ComPDFKit.openDocument(pdfFile.path,
                           password: '', configuration: configuration);
  }
}
```

#### Usage Widget

Open `lib/main.dart`,replace the entire file with the following:

```dart
import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:flutter/material.dart';

const String _documentPath = 'pdfs/PDF_Document.pdf';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _document;

  @override
  void initState() {
    super.initState();
    _init();
    _getDocumentPath().then((value) {
      setState(() {
        _document = value;
      });
    });
  }

  void _init() async {
    /// Please replace it with your ComPDFKit license
    File licenseFile = await CPDFFileUtil.extractAsset(context, 'assets/license_key_flutter.xml');
    ComPDFKit.initWithPath(licenseFile.path);
  }

  Future<String> _getDocumentPath() async {
    var file = await CPDFFileUtil.extractAsset('pdfs/PDF_Document.pdf');
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('CPDFReaderWidget Example'),
        ),
        body: _document == null
        ? Container()
        : CPDFReaderWidget(
          document: _document!,
          configuration: CPDFConfiguration(),
          onCreated: (_create) => {})));
  }
}
```

Start your Android emulator, or connect a device, Run the app with:

```bash
flutter run
```

### Example APP

To see [ComPDF for Flutter](https://www.compdf.com/contact-sales?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter) in action, check out our [Flutter example app](example/) and [API reference](https://pub.dev/documentation/compdfkit_flutter/latest/compdfkit/compdfkit-library.html).

Showing a PDF document inside your Flutter app is as simple as this:

```dart
/// First. Please replace it with your ComPDFKit license

// Include the license in Flutter assets and copy to device storage
// Add `license_key_flutter.xml` to your Flutter project’s assets directory;
File licenseFile = await CPDFFileUtil.extractAsset('assets/license_key_flutter.xml');
ComPDFKit.initWithPath(licenseFile.path);

/// open pdf document
ComPDFKit.openDocument(tempDocumentPath, password: '', configuration:  CPDFConfiguration());

/// Here’s how you can open a PDF document using CPDFReaderWidget:
Scaffold(
  resizeToAvoidBottomInset: false,
  appBar: AppBar(title: const Text('CPDFReaderWidget Example'),),
  body: CPDFReaderWidget(
    document: widget.documentPath,
    configuration: CPDFConfiguration()
  ));
```

---

## Changelog

Keep up with the latest updates, improvements, and bug fixes for ComPDF SDK for Flutter: [View Flutter Changelog](https://www.compdf.com/pdf-sdk/changelog-flutter?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter)

---

## Free Trial & License

[ComPDF SDK for Flutter](https://www.compdf.com/?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter) offers a **30-day free trial** so you can evaluate core PDF capabilities in your own application.

To get started:

1. Apply for a [free trial](https://www.compdf.com/pricing?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter)
2. Review supported trial features and licensing details
3. Follow the integration and license steps above to activate the SDK in your project

For custom deployments, advanced features, or volume licensing, please [contact our sales team](https://www.compdf.com/contact-sales?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter)

---

## Support

[ComPDF](https://www.compdf.com/?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter) has a professional R&D team that produces comprehensive technical documentation and guides to help developers. Also, you can get an immediate response when reporting your problems to our support team.

- For detailed information, please visit our [Guides](https://www.compdf.com/guides/pdf-sdk/flutter/overview?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter) page.
- For technical assistance, please reach out to our [Technical Support](https://www.compdf.com/support?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter).
- To get more details and an accurate quote, please contact our [Sales Team](https://www.compdf.com/contact-sales?utm_source=github_readme_sdk_flutter&utm_medium=referral&utm_campaign=github_readme_sdk_flutter) or [send an email](mailto:support@compdf.com).
