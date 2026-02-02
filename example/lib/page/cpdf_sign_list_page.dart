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

final signPicList = [
  'images/sign/signature_1.png',
  'images/sign/signature_2.png',
  'images/sign/signature_3.png',
  'images/sign/signature_4.png',
];

class CpdfSignListPage extends StatefulWidget {
  const CpdfSignListPage({super.key});

  @override
  State<CpdfSignListPage> createState() => _CpdfSignListPageState();
}

class _CpdfSignListPageState extends State<CpdfSignListPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 244,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView.builder(
        itemCount: signPicList.length,
        itemBuilder: (itemContext, index) {
          return InkWell(
            onTap: () async {
              final file = await CPDFFileUtil.extractAsset(signPicList[index]);
              if (!itemContext.mounted) return;
              Navigator.pop(itemContext, file.path);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                signPicList[index],
                width: double.infinity,
                height: 45,
              ),
            ),
          );
        },
      ),
    );
  }
}
