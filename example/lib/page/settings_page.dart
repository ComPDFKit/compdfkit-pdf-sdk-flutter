// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.
import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 4,
          excludeHeaderSemantics: true,
          titleSpacing: 0,
          title: const Text('Settings'),
        ),
        body: Column(
          children: [
            Column(
              children: [
                head(context, 'SDK Information'),
                item(context, 'Versions',
                    trailing: FutureBuilder(
                        future: ComPDFKit.getVersionCode(),
                        builder: (context, snap) {
                          return Text(snap.data == null ? '' : 'ComPDFKit ${snap.data} for ${Platform.operatingSystem}',
                              style: Theme.of(context).textTheme.bodyMedium);
                        })),
                head(context, 'Company Information'),
                item(context,
                    'https://www.compdf.com/',
                    onTap: () => launchUrl(Uri.parse('https://www.compdf.com/'))),
                item(context, 'About ComPDFKit',
                    onTap: () => launchUrl(Uri.parse(
                        'https://www.compdf.com/company/about'))),
                item(context, 'Technical Support',
                    onTap: () => launchUrl(Uri.parse('https://www.compdf.com/support'))),
                item(context, 'Contact Sales',
                    onTap: () => launchUrl(Uri.parse('https://www.compdf.com/contact-sales'))),
                item(context, 'support@compdf.com',
                    onTap: () {
                  launchUrl(Uri.parse(
                      'mailto:support@compdf.com?subject=Technical Support'));
                }),
              ],
            ),
            Expanded(
                child: SafeArea(
                    child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '© 2014-2025 PDF Technologies, Inc. All Rights Reserved.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: 'Privacy Policy',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11, color: const Color(0xFF1460F3)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                                Uri.parse('https://www.compdf.com/privacy-policy'),
                              )),
                    const TextSpan(text: ' | '),
                    TextSpan(
                        text: 'Terms of Service',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11, color: const Color(0xFF1460F3)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                                Uri.parse('https://www.compdf.com/terms-of-service'),
                              )),
                  ])),
                ],
              ),
            )))
          ],
        ));
  }

  Widget head(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF303238)
          : const Color(0xFFF2F2F2),
      child: Text(title, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  Widget item(BuildContext context, String title,
      {Widget? trailing, GestureTapCallback? onTap}) {
    return ListTile(
        onTap: onTap,
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        trailing: trailing ??
            SvgPicture.asset(
              'images/ic_syasarrow.svg'
            ));
  }

}
