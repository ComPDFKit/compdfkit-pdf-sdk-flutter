# PDF SDK for Flutter | View, Annotate, Edit & Sign PDFs in Mobile Apps

ComPDF for Flutter helps developers build mobile PDF experiences on iOS and Android with PDF viewing, annotation, editing, form filling, redaction, and signatures. For products that also need **Convert**, **OCR**, and **Generate** workflows, ComPDF can be paired with ComPDF API to support end-to-end **document workflow** and **automation** use cases.

## 🚀 Why ComPDF

ComPDF is designed for teams that want a production-ready PDF layer in Flutter without stitching together a low-level renderer, custom UI, and separate commercial support.

Why developers choose it:

- **Mobile performance:** fast, high-fidelity PDF rendering for real app usage, including large documents.
- **Cross-platform delivery:** one Flutter integration for both **iOS and Android**.
- **Built-in UI + Flutter embedding:** open documents with the default UI or embed `CPDFReaderWidget` in your own Flutter screen.
- **Commercial readiness:** trial license, enterprise licensing, SDK support, and API options for broader document workflows.
- **Cleaner integration path:** easier to ship than building document review and editing experiences from scratch.

## 🎬 Live Demo

Try ComPDF in action:

- Web Demo: [https://www.compdf.com/demo/webviewer](https://www.compdf.com/demo/webviewer)
- Sample Project: [https://github.com/ComPDFKit/compdfkit-pdf-sdk-flutter/tree/main/example](https://github.com/ComPDFKit/compdfkit-pdf-sdk-flutter/tree/main/example)
- Video Demo: [https://youtu.be/I0Rz11iVAbE](https://youtu.be/I0Rz11iVAbE)

## ⚡ Quick Start

> Requirements: Flutter latest stable, Android `minSdkVersion 21+`, iOS `12+`.

### 1. Install

```bash
flutter pub add compdfkit_flutter
```

### 2. Add your license and sample PDF

```yaml
flutter:
  assets:
    - assets/license_key_flutter.xml
    - pdfs/PDF_Document.pdf
```

**Platform notes**

- **Android:** use `minSdkVersion 21` or above.
- **Android:** if you use `CPDFReaderWidget`, use `FlutterFragmentActivity`.
- **iOS:** use iOS 12+ and follow the official Pod integration guide when adding native ComPDF pods manually.

### 3. Initialize and open a PDF

```dart
import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:flutter/material.dart';

const String documentAsset = 'pdfs/PDF_Document.pdf';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initializeSdk();
  }

  Future<void> _initializeSdk() async {
    final File licenseFile = await CPDFFileUtil.extractAsset(
      context,
      'assets/license_key_flutter.xml',
    );
    await ComPDFKit.initWithPath(licenseFile.path);
  }

  Future<void> _openDocument() async {
    final pdfFile = await CPDFFileUtil.extractAsset(documentAsset);
    ComPDFKit.openDocument(
      pdfFile.path,
      password: '',
      configuration: CPDFConfiguration(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _openDocument,
          child: const Text('Open PDF'),
        ),
      ),
    );
  }
}
```

## 🧩 Key Features

- 📄 **PDF Viewing & Navigation**  
  View PDFs with smooth scrolling, thumbnails, and search-ready reading experiences.  
  👉 Use case: mobile document readers, case files, knowledge apps

- ✍️ **Annotation & Review**  
  Highlight, comment, draw, and review documents inside the app.  
  👉 Use case: contract review, classroom markup, team approval flows

- 🛠️ **Editing, Forms, Redaction & Signatures**  
  Go beyond viewing with document completion and protection features.  
  👉 Use case: onboarding forms, signed agreements, compliance workflows

- 🧱 **Plugin UI or Embedded Widget**  
  Choose the default viewer for fast rollout or `CPDFReaderWidget` for tighter Flutter UI integration.  
  👉 Use case: branded document screens inside mobile apps

- 🔄 **Works with Convert / OCR / Generate Pipelines**  
  Pair the mobile SDK with ComPDF API when your app also needs backend document processing.  
  👉 Use case: invoice capture apps, searchable archive workflows, generated PDF outputs

## 💡 Use Cases

- **Document Management Systems** for mobile viewing, review, and approval
- **PDF Editors** embedded in Flutter apps
- **Invoice Processing** apps that upload files from mobile and route OCR/conversion to backend workflows
- **Field Service & Sales Apps** for forms, checklists, contracts, and signatures
- **Legal, Finance, and Healthcare Apps** that need secure document review on mobile

## 🧪 Code Snippets

### Open a document with the built-in viewer

```dart
import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:flutter/material.dart';

Future<void> openSampleDocument(BuildContext context) async {
  final File licenseFile = await CPDFFileUtil.extractAsset(
    context,
    'assets/license_key_flutter.xml',
  );
  await ComPDFKit.initWithPath(licenseFile.path);

  final pdfFile = await CPDFFileUtil.extractAsset('pdfs/PDF_Document.pdf');
  ComPDFKit.openDocument(
    pdfFile.path,
    password: '',
    configuration: CPDFConfiguration(),
  );
}
```

### Embed `CPDFReaderWidget` and enable only viewer + annotation modes

```dart
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key, required this.documentPath});

  final String documentPath;

  @override
  Widget build(BuildContext context) {
    final configuration = CPDFConfiguration(
      modeConfig: ModeConfig(
        initialViewMode: CPreviewMode.viewer,
        availableViewModes: [
          CPreviewMode.viewer,
          CPreviewMode.annotations,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Review PDF')),
      body: CPDFReaderWidget(
        document: documentPath,
        configuration: configuration,
      ),
    );
  }
}
```

## 🔗 Documentation & Resources

| Resource | Link |
| --- | --- |
| Official Docs | [https://www.compdf.com/guides/pdf-sdk/flutter/overview](https://www.compdf.com/guides/pdf-sdk/flutter/overview) |
| API Reference | [https://pub.dev/documentation/compdfkit_flutter/latest/](https://pub.dev/documentation/compdfkit_flutter/latest/) |
| GitHub | [https://github.com/ComPDFKit/compdfkit-pdf-sdk-flutter](https://github.com/ComPDFKit/compdfkit-pdf-sdk-flutter) |
| Demo | [https://github.com/ComPDFKit/compdfkit-pdf-sdk-flutter/tree/main/example](https://github.com/ComPDFKit/compdfkit-pdf-sdk-flutter/tree/main/example) |

## ❤️ Engagement

If you find this package useful, please 👍 **Like it on pub.dev** to support us!

ComPDF is a practical PDF SDK for Flutter teams that need mobile UI integration today and room to expand into larger document workflows later.
