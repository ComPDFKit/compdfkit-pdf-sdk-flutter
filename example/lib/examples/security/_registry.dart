// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import '../shared/category_info.dart';
import '../shared/example_item.dart';
import '../shared/example_route_type.dart';
import 'background_example.dart';
import 'bates_example.dart';
import 'certificate_management_example.dart';
import 'digital_signature_example.dart';
import 'document_permissions_example.dart';
import 'header_footer_example.dart';
import 'remove_password_example.dart';
import 'set_password_example.dart';
import 'watermark_example.dart';

/// Security category registry file
///
/// Contains PDF security related examples
final CategoryInfo securityCategory = CategoryInfo(
  id: 'security',
  name: 'Security',
  icon: Icons.security,
  description: 'Password, watermark, headers, permissions and signatures',
  examples: [
    ExampleItem(
      title: 'Set Password',
      description: 'Set document password',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const SetPasswordExample(),
      visual: const ExampleVisual(
        icon: Icons.lock,
        backgroundColor: Color(0xFFFFEBEE),
        iconColor: Color(0xFFC62828),
      ),
    ),
    ExampleItem(
      title: 'Remove Password',
      description: 'Remove document password',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const RemovePasswordExample(),
      visual: const ExampleVisual(
        icon: Icons.lock_open,
        backgroundColor: Color(0xFFE8F5E9),
        iconColor: Color(0xFF388E3C),
      ),
    ),
    ExampleItem(
      title: 'Watermark',
      description: 'Add, inspect, update, or remove watermarks',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const WatermarkExample(),
      visual: const ExampleVisual(
        icon: Icons.water_drop,
        backgroundColor: Color(0xFFE0F2F1),
        iconColor: Color(0xFF00796B),
      ),
    ),
    ExampleItem(
      title: 'Header & Footer',
      description:
          'Add, inspect, update, and clear document headers and footers',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const HeaderFooterExample(),
      visual: const ExampleVisual(
        icon: Icons.vertical_align_center,
        backgroundColor: Color(0xFFFFF3E0),
        iconColor: Color(0xFFE65100),
      ),
    ),
    ExampleItem(
      title: 'Bates Numbering',
      description: 'Apply, inspect, update, or clear Bates numbering',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const BatesExample(),
      visual: const ExampleVisual(
        icon: Icons.tag,
        backgroundColor: Color(0xFFE8EAF6),
        iconColor: Color(0xFF3949AB),
      ),
    ),
    ExampleItem(
      title: 'Document Background',
      description: 'Set, inspect, update, and clear color or image backgrounds',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const BackgroundExample(),
      visual: const ExampleVisual(
        icon: Icons.wallpaper,
        backgroundColor: Color(0xFFE0F7FA),
        iconColor: Color(0xFF00838F),
      ),
    ),
    ExampleItem(
      title: 'Document Permissions',
      description: 'View permissions and encryption info',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const DocumentPermissionsExample(),
      visual: const ExampleVisual(
        icon: Icons.admin_panel_settings,
        backgroundColor: Color(0xFFFCE4EC),
        iconColor: Color(0xFFC2185B),
      ),
    ),
    ExampleItem(
      title: 'Digital Signature',
      description:
          'Sign a signature field with a timestamp, verify it, and add LTV',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const DigitalSignatureExample(),
      visual: const ExampleVisual(
        icon: Icons.verified_user,
        backgroundColor: Color(0xFFEFF7FF),
        iconColor: Color(0xFF0D47A1),
      ),
    ),
    ExampleItem(
      title: 'Certificate Management',
      description: 'Create, inspect, and trust a PKCS#12 certificate',
      routeType: ExampleRouteType.pageBuilder,
      pageBuilder: (context) => const CertificateManagementExample(),
      visual: const ExampleVisual(
        icon: Icons.card_membership,
        backgroundColor: Color(0xFFE8F5E9),
        iconColor: Color(0xFF2E7D32),
      ),
    ),
  ],
);
