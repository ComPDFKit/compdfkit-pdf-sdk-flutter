// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Company information constants for ComPDFKit.
///
/// This file centralizes the management of all company-related information,
/// including URLs, contact details, and legal text.
/// All company information should be referenced from this file to ensure consistency.
class AppConstants {
  AppConstants._();

  // ==================== Company Details ====================

  /// Default document author name
  static const String documentAuthor = 'ComPDFKit';

  /// Support email address
  static const String supportEmail = 'support@compdf.com';

  /// Copyright notice text
  static const String copyrightNotice =
      '© 2014-2026 PDF Technologies, Inc. All Rights Reserved.';

  // ==================== Company URLs ====================

  /// Main website URL
  static const String websiteUrl = 'https://www.compdf.com/';

  /// About us page URL
  static const String aboutUsUrl = 'https://www.compdf.com/company/about';

  /// Technical support page URL
  static const String technicalSupportUrl = 'https://www.compdf.com/support';

  /// Contact sales page URL
  static const String contactSalesUrl = 'https://www.compdf.com/contact-sales';

  /// Support email mailto link
  static const String supportEmailUrl =
      'mailto:support@compdf.com?subject=Technical Support';

  /// Privacy policy page URL
  static const String privacyPolicyUrl =
      'https://www.compdf.com/privacy-policy';

  /// Terms of service page URL
  static const String termsOfServiceUrl =
      'https://www.compdf.com/terms-of-service';
}
