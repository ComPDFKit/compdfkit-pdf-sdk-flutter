// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:compdfkit_flutter_example/utils/preferences_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('highlight settings default to true', () async {
    await PreferencesService.init();

    expect(PreferencesService.highlightLink, isTrue);
    expect(PreferencesService.highlightForm, isTrue);
  });

  test('highlight settings preserve an explicitly saved false value', () async {
    await PreferencesService.init();
    await PreferencesService.setHighlightLink(false);
    await PreferencesService.setHighlightForm(false);

    expect(PreferencesService.highlightLink, isFalse);
    expect(PreferencesService.highlightForm, isFalse);
  });
}
