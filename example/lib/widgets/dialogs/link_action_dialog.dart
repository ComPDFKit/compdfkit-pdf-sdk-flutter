// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/document/action/cpdf_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_goto_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_named_action.dart';
import 'package:compdfkit_flutter/document/action/cpdf_uri_action.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// The type of link action for categorization and display purposes.
enum LinkActionType {
  /// Web URL link (http/https)
  web,

  /// Email link (mailto:)
  email,

  /// Page navigation within the document
  page,

  /// Named action (first/last/next/prev page)
  namedAction,

  /// Unknown or undefined action
  unknown,
}

/// Data class representing a link action with its display properties.
class LinkActionData {
  /// The type of link action.
  final LinkActionType type;

  /// The icon to display in the dialog header.
  final IconData icon;

  /// The title displayed in the dialog header.
  final String title;

  /// The content to display (URL, email, or page number).
  final String content;

  /// The text for the action button.
  final String buttonText;

  /// The callback to execute when the action button is pressed.
  final VoidCallback? onAction;

  const LinkActionData({
    required this.type,
    required this.icon,
    required this.title,
    required this.content,
    required this.buttonText,
    this.onAction,
  });

  /// Creates a [LinkActionData] for a web URL.
  factory LinkActionData.web({
    required String url,
    required VoidCallback onAction,
  }) {
    return LinkActionData(
      type: LinkActionType.web,
      icon: Icons.link,
      title: 'Web Link',
      content: url,
      buttonText: 'Open Link',
      onAction: onAction,
    );
  }

  /// Creates a [LinkActionData] for an email link.
  factory LinkActionData.email({
    required String email,
    required VoidCallback onAction,
  }) {
    return LinkActionData(
      type: LinkActionType.email,
      icon: Icons.email_outlined,
      title: 'Email',
      content: email,
      buttonText: 'Send Email',
      onAction: onAction,
    );
  }

  /// Creates a [LinkActionData] for page navigation.
  factory LinkActionData.page({
    required int pageIndex,
    required VoidCallback onAction,
  }) {
    return LinkActionData(
      type: LinkActionType.page,
      icon: Icons.description_outlined,
      title: 'Go to Page',
      content: 'Page ${pageIndex + 1}',
      buttonText: 'Jump',
      onAction: onAction,
    );
  }

  /// Creates a [LinkActionData] for unknown action types.
  factory LinkActionData.unknown({String? message}) {
    return LinkActionData(
      type: LinkActionType.unknown,
      icon: Icons.link_off,
      title: 'Link',
      content: message ?? 'No action defined',
      buttonText: 'Close',
      onAction: null,
    );
  }

  /// Creates a [LinkActionData] for named actions (first/last/next/prev page).
  factory LinkActionData.namedAction({
    required CPDFNamedActionType namedActionType,
    required VoidCallback onAction,
  }) {
    final (icon, title, content, buttonText) = switch (namedActionType) {
      CPDFNamedActionType.firstPage => (
          Icons.first_page,
          'First Page',
          'Go to the first page of the document',
          'Go to First',
        ),
      CPDFNamedActionType.lastPage => (
          Icons.last_page,
          'Last Page',
          'Go to the last page of the document',
          'Go to Last',
        ),
      CPDFNamedActionType.nextPage => (
          Icons.navigate_next,
          'Next Page',
          'Go to the next page',
          'Next',
        ),
      CPDFNamedActionType.prevPage => (
          Icons.navigate_before,
          'Previous Page',
          'Go to the previous page',
          'Previous',
        ),
      CPDFNamedActionType.none => (
          Icons.help_outline,
          'Unknown Action',
          'Unknown named action type',
          'Close',
        ),
      CPDFNamedActionType.print => (
          Icons.print,
          'Print Document',
          'Print the current document',
          'Print',
        ),  
    };

    return LinkActionData(
      type: LinkActionType.namedAction,
      icon: icon,
      title: title,
      content: content,
      buttonText: buttonText,
      onAction: namedActionType != CPDFNamedActionType.none ? onAction : null,
    );
  }
}

/// A dialog for displaying link annotation actions.
///
/// This dialog supports different types of links:
/// - Web URLs (http/https)
/// - Email links (mailto:)
/// - Page navigation within the document
///
/// ## Usage Example
///
/// ### Using LinkActionData directly
///
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => LinkActionDialog(
///     data: LinkActionData.web(
///       url: 'https://example.com',
///       onAction: () {
///         Navigator.pop(context);
///         launchUrl(Uri.parse('https://example.com'));
///       },
///     ),
///   ),
/// );
/// ```
///
/// ### Using the convenience show method
///
/// ```dart
/// // For web links
/// LinkActionDialog.showWebLink(
///   context: context,
///   url: 'https://example.com',
/// );
///
/// // For email links
/// LinkActionDialog.showEmailLink(
///   context: context,
///   email: 'test@example.com',
/// );
///
/// // For page navigation
/// LinkActionDialog.showPageLink(
///   context: context,
///   pageIndex: 5,
///   onJump: () => controller.setDisplayPageIndex(pageIndex: 5),
/// );
/// ```
class LinkActionDialog extends StatelessWidget {
  /// The link action data containing display properties and action callback.
  final LinkActionData data;

  /// The primary color used for the header background.
  final Color primaryColor;

  const LinkActionDialog({
    super.key,
    required this.data,
    this.primaryColor = const Color(0xFF1976D2),
  });

  /// Shows a [LinkActionDialog] for a web URL.
  static Future<void> showWebLink({
    required BuildContext context,
    required String url,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => LinkActionDialog(
        data: LinkActionData.web(
          url: url,
          onAction: () async {
            Navigator.of(dialogContext).pop();
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
        ),
      ),
    );
  }

  /// Shows a [LinkActionDialog] for an email link.
  static Future<void> showEmailLink({
    required BuildContext context,
    required String email,
  }) {
    final emailUri = email.startsWith('mailto:') ? email : 'mailto:$email';
    final displayEmail =
        email.startsWith('mailto:') ? email.replaceFirst('mailto:', '') : email;

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => LinkActionDialog(
        data: LinkActionData.email(
          email: displayEmail,
          onAction: () async {
            Navigator.of(dialogContext).pop();
            final uri = Uri.parse(emailUri);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
        ),
      ),
    );
  }

  /// Shows a [LinkActionDialog] for page navigation.
  static Future<void> showPageLink({
    required BuildContext context,
    required int pageIndex,
    required VoidCallback onJump,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => LinkActionDialog(
        data: LinkActionData.page(
          pageIndex: pageIndex,
          onAction: () {
            Navigator.of(dialogContext).pop();
            onJump();
          },
        ),
      ),
    );
  }

  /// Shows a [LinkActionDialog] for unknown or undefined actions.
  static Future<void> showUnknown({
    required BuildContext context,
    String? message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => LinkActionDialog(
        data: LinkActionData.unknown(message: message),
      ),
    );
  }

  /// Shows a [LinkActionDialog] for named actions (first/last/next/prev page).
  ///
  /// The [onAction] callback is required to handle the navigation action.
  /// It will be called when the user taps the action button.
  static Future<void> showNamedAction({
    required BuildContext context,
    required CPDFNamedActionType namedActionType,
    required VoidCallback onAction,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => LinkActionDialog(
        data: LinkActionData.namedAction(
          namedActionType: namedActionType,
          onAction: () {
            Navigator.of(dialogContext).pop();
            onAction();
          },
        ),
      ),
    );
  }

  /// Shows a [LinkActionDialog] based on the provided [CPDFAction].
  ///
  /// This method automatically determines the action type and displays
  /// the appropriate dialog.
  ///
  /// Supported action types:
  /// - [CPDFUriAction]: Displays web link or email link dialog
  /// - [CPDFGoToAction]: Displays page navigation dialog
  /// - [CPDFNamedAction]: Displays named action dialog (first/last/next/prev page)
  ///
  /// ## Parameters
  /// - [context]: The build context
  /// - [action]: The CPDFAction to display (can be null)
  /// - [onGoToPage]: Callback for page navigation (required for GoTo actions)
  /// - [onNamedAction]: Callback for named actions (required for Named actions)
  ///
  /// ## Example
  /// ```dart
  /// LinkActionDialog.showFromAction(
  ///   context: context,
  ///   action: linkAnnotation.action,
  ///   onGoToPage: (pageIndex) {
  ///     controller.setDisplayPageIndex(pageIndex: pageIndex);
  ///   },
  ///   onNamedAction: (type) {
  ///     switch (type) {
  ///       case CPDFNamedActionType.firstPage:
  ///         controller.setDisplayPageIndex(pageIndex: 0);
  ///         break;
  ///       // ... handle other types
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> showFromAction({
    required BuildContext context,
    CPDFAction? action,
    void Function(int pageIndex)? onGoToPage,
    void Function(CPDFNamedActionType type)? onNamedAction,
  }) {
    if (action == null) {
      return showUnknown(context: context);
    }

    switch (action) {
      case CPDFUriAction(:final uri):
        if (uri.startsWith('mailto:')) {
          return showEmailLink(context: context, email: uri);
        } else {
          return showWebLink(context: context, url: uri);
        }

      case CPDFGoToAction(:final pageIndex):
        return showPageLink(
          context: context,
          pageIndex: pageIndex,
          onJump: () => onGoToPage?.call(pageIndex),
        );

      case CPDFNamedAction(:final namedAction):
        return showNamedAction(
          context: context,
          namedActionType: namedAction,
          onAction: () => onNamedAction?.call(namedAction),
        );

      default:
        return showUnknown(
          context: context,
          message: 'Unsupported action type: ${action.actionType.name}',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(data.icon, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              data.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, size: 22, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              data.content,
              style: const TextStyle(
                color: Color(0xFF424242),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: data.onAction ?? () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              data.buttonText,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
