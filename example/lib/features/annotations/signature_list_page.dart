/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';

final signPicList = [
  AppAssets.signatureOne,
  AppAssets.signatureTwo,
  AppAssets.signatureThree,
  AppAssets.signatureFour,
];

class SignatureListPage extends StatefulWidget {
  const SignatureListPage({super.key});

  @override
  State<SignatureListPage> createState() => _SignatureListPageState();
}

class _SignatureListPageState extends State<SignatureListPage> {
  int _tappedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: signPicList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (itemContext, index) {
          final isTapped = _tappedIndex == index;

          return Material(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                setState(() => _tappedIndex = index);
                final file =
                    await CPDFFileUtil.extractAsset(signPicList[index]);
                if (!itemContext.mounted) return;
                Navigator.pop(itemContext, file.path);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isTapped
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isTapped
                      ? colorScheme.primaryContainer
                      : colorScheme.surface,
                ),
                child: Image.asset(
                  signPicList[index],
                  height: 45,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
