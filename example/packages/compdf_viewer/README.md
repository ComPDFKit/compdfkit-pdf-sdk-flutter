# PDF Viewer

A full-featured PDF viewer Flutter package built on top of [ComPDFKit Flutter SDK](https://pub.dev/packages/compdfkit_flutter). This package provides a complete PDF reading experience with annotations, bookmarks, search, thumbnails, and more, using GetX for state management.

## Features

- **PDF Viewing**: Full document rendering with multiple display modes (single/double page, continuous scroll)
- **Annotations**: Support for notes, highlights, underlines, strikeouts, ink drawings, shapes, stamps, signatures, and more
- **Bookmarks**: Add, edit, and navigate bookmarks
- **Outline/TOC**: Navigate document structure via table of contents
- **Thumbnails**: Visual page navigation with thumbnail previews
- **Text Search**: Full-text search with context snippets and result highlighting
- **Document Info**: View PDF metadata, permissions, and file properties
- **Security**: Password protection and encryption support
- **Export**: Convert PDF pages to images, flatten annotations
- **Content Editor**: Edit PDF content directly
- **Localization**: Built-in English and Chinese translations
- **Dark Mode**: Responsive UI with dark mode support

## Directory Structure

```
lib/
  compdf_viewer.dart              # Main entry and exports
  core/                           # Core: config, global settings, bindings, constants
    config.dart
    global.dart
    bindings.dart
    constants.dart
  features/                       # Feature modules
    viewer/                       # Main PDF viewer
      pdf_viewer_page.dart        # Main page widget
      controller/                 # Viewer controller
      model/                      # Viewer state models
      widgets/                    # Viewer UI components
    annotation/                   # Annotation tools
      controller/                 # Annotation controller
      model/                      # Annotation models
      widgets/                    # Annotation UI components
    bota/                         # Bookmarks, Outlines, Thumbnails, Annotations list
      bota_page.dart              # BOTA panel page
      bookmarks/                  # Bookmark management
      outlines/                   # Outline navigation
      thumbnails/                 # Thumbnail grid view
      annotations/                # Annotations list view
      widgets/                    # Shared BOTA widgets
    search/                       # Text search functionality
    navigation/                   # Side drawer navigation
    security/                     # Encryption/password features
    convert/                      # PDF to image conversion
    info/                         # Document info display
  l10n/                           # Localization
    pdf_locale_keys.dart
    pdf_viewer_translations.dart
    locale/
      en_us.dart
      zh_cn.dart
  router/                         # GetX routing
    pdf_viewer_routes.dart
    pdf_viewer_pages.dart
  shared/                         # Shared components
    controllers/                  # Global settings controller
    widgets/                      # Reusable UI components
      buttons/
      dialogs/
      indicators/
  utils/                          # Utility classes
    file_util.dart
    pdf_dir_util.dart
    pdf_page_util.dart
    pdf_viewer_document_util.dart
    pdf_global_settings_data.dart
    screen_util.dart
    snackbar_util.dart
```

## Getting Started

### Prerequisites

- Flutter SDK >= 3.3.0
- Dart SDK >= 3.0.5
- ComPDFKit license (obtain from [ComPDFKit](https://www.compdf.com/))

### Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  compdf_viewer:
    path: packages/compdf_viewer
```

Then run:

```bash
flutter pub get
```

### Initialize ComPDFKit

Before using the PDF viewer, initialize ComPDFKit with your license:

```dart
import 'package:compdf_viewer/compdf_viewer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize with your license key
  await PdfViewerGlobal.init('assets/license_key_flutter.xml');
  
  runApp(MyApp());
}
```

## Usage

### Basic Usage with GetX

```dart
import 'package:get/get.dart';
import 'package:compdf_viewer/compdf_viewer.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Add PDF Viewer translations
      translations: PdfViewerTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      
      // Add PDF Viewer routes
      getPages: [
        ...PdfViewerPages.routes,
        // Your other routes...
      ],
      
      home: HomePage(),
    );
  }
}
```

### Navigate to PDF Viewer

```dart
// Navigate to PDF viewer with a file path
Get.toNamed(
  PdfViewerRoutes.pdfPage,
  arguments: {'document': '/path/to/document.pdf'},
);
```

### Navigate to Other Pages

```dart
// Navigate to BOTA page (Bookmarks, Outlines, Thumbnails, Annotations)
Get.toNamed(
  PdfViewerRoutes.bota,
  arguments: 'annotation', // Initial tab: 'annotation', 'outline', or 'bookmark'
);

// Navigate to thumbnail page
final selectedPage = await Get.toNamed(PdfViewerRoutes.thumbnail);
if (selectedPage is int) {
  controller.jumpToPage(selectedPage);
}

// Navigate to document info page
Get.toNamed(PdfViewerRoutes.documentInfo);

// Navigate to search page
Get.toNamed(PdfViewerRoutes.pdfSearch);
```

### Use PDFViewerContent Widget Directly

```dart
import 'package:compdf_viewer/compdf_viewer.dart';

class MyPDFPage extends StatelessWidget {
  final String filePath;
  
  const MyPDFPage({required this.filePath});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfViewerContent(
        documentPath: filePath,
      ),
    );
  }
}
```

### Configuration

Customize the PDF viewer configuration:

```dart
import 'package:compdf_viewer/compdf_viewer.dart';

// Get default configuration
final config = await getCpdfConfig();

// Or customize as needed
final customConfig = CPDFConfiguration(
  toolbarConfig: CPDFToolbarConfig(
    availableMenus: [/* your menu items */],
  ),
  // ... other options
);
```

## Dependencies

This package uses the following key dependencies:

| Package | Purpose |
|---------|---------|
| **get** | State management, dependency injection, and routing |
| **compdfkit_flutter** | PDF SDK core functionality |
| **logger** | Logging utilities |
| **shared_preferences** | Persistent storage for settings |
| **flutter_colorpicker** | Color picker for annotation properties |
| **share_plus** | File sharing |
| **file_picker** | File selection |
| **path_provider** | Directory access |
| **path** | Path manipulation utilities |
| **flutter_svg** | SVG rendering for icons |
| **url_launcher** | Opening URLs |

## Architecture

This package follows a feature-based architecture with GetX pattern:

```
┌─────────────────────────────────────────────────────────────┐
│                        compdf_viewer                         │
├─────────────────────────────────────────────────────────────┤
│  Core          │  Features      │  Shared       │  Router   │
│  ├─ global     │  ├─ viewer     │  ├─ widgets   │  ├─ routes│
│  ├─ config     │  ├─ annotation │  ├─ controllers│ └─ pages │
│  ├─ bindings   │  ├─ bota       │  └─ dialogs   │           │
│  └─ constants  │  ├─ search     │               │           │
│                │  ├─ navigation │               │           │
│                │  ├─ security   │               │           │
│                │  ├─ convert    │               │           │
│                │  └─ info       │               │           │
├─────────────────────────────────────────────────────────────┤
│                    compdfkit_flutter SDK                     │
└─────────────────────────────────────────────────────────────┘
```

### Key Components

- **Controllers**: Business logic and state management (`GetxController`)
- **State**: Reactive state classes with `Rx` observables
- **Repository**: Data access layer (optional, per feature)
- **Bindings**: Dependency injection setup
- **Views/Widgets**: UI components

Each feature module (annotation, bookmark, search, etc.) follows this structure for consistency and maintainability.

### Key Classes

| Class | Description |
|-------|-------------|
| `PdfViewerGlobal` | SDK initialization and logger |
| `PdfViewerController` | Main PDF viewer controller |
| `PdfAnnotationToolBarController` | Annotation tool management |
| `PdfSearchController` | Text search functionality |
| `PdfViewerRoutes` | Route constants |
| `PdfViewerPages` | GetX page configuration |

## License

This package is part of the ComPDFKit Flutter SDK example project. Usage is subject to the [ComPDFKit License Agreement](https://www.compdf.com/policy/license-agreement).

## Additional Information

- [ComPDFKit Flutter SDK Documentation](https://www.compdf.com/guides/pdf-sdk/flutter/overview)
- [ComPDFKit API Reference](https://developers.compdf.com/)
- [Report Issues](https://github.com/ComPDFKit/compdfkit-pdf-sdk-flutter/issues)
