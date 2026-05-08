// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/foundation.dart';

/// Centralized platform capability checks for the example app.
class PlatformCapability {
  PlatformCapability._();

  static bool get isWeb => kIsWeb;

  static bool get supportsComPDFKitNative =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static bool get supportsEmbeddedReader => supportsComPDFKitNative;

  static bool get supportsExampleCatalog => supportsComPDFKitNative;

  static String get nativeFeatureUnavailableMessage =>
      'This feature is not supported on Web yet. Use Android or iOS.';
}
