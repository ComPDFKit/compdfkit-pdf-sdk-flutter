/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/asset_paths.dart';
import '../app/settings_page.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

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
              AppAssets.icHomeSettings,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
            ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 56);
}
