/*
 * Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../page/settings_page.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('ComPDFKit SDK for Flutter'),
      actions: [
        IconButton(
            padding: const EdgeInsets.all(16),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SettingsPage();
              }));
            },
            icon: SvgPicture.asset(
              'images/ic_home_setting.svg',
              width: 24,
              height: 24,
              color: Theme.of(context).colorScheme.onPrimary,
            ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 56);
}
