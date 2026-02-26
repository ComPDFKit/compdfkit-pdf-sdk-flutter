// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/compdf_viewer.dart';

import '../constants/asset_paths.dart';
import '../examples/registry.dart';
import '../examples/viewer/modal_viewer_example.dart';
import '../theme/themes.dart';
import 'category_page.dart';
import 'settings_page.dart';
import 'widgets/category_list_tile.dart';
import 'widgets/featured_card.dart';
import 'widgets/home_header.dart';

/// Example Home Page
class HomePage extends StatelessWidget {
  /// Constructor
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUiOverlayStyle(brightness),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HomeHeader(
                onSettingsTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsPage(),
                    ),
                  );
                },
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                    itemCount: allCategories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: FeaturedCard(
                            title: 'PDF Viewer',
                            description:
                                'Full-featured PDF viewer with navigation, search, annotations and more',
                            icon: Icons.auto_awesome,
                            onTap: () {
                              showPdfPickerModal(
                                context,
                                defaultAssetPath: AppAssets.pdfDocument,
                                onDocumentSelected: (path) {
                                  Get.toNamed(
                                    PdfViewerRoutes.pdfPage,
                                    arguments: {'document': path},
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                      final category = allCategories[index - 1];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CategoryListTile(
                          category: category,
                          index: index - 1,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CategoryPage(category: category),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
