// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeatureItem extends StatelessWidget {
  final String title;

  final String description;

  final GestureTapCallback onTap;

  const FeatureItem(
      {super.key,
      required this.title,
      required this.description,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'images/ic_home_viewer.svg',
              width: 38,
              height: 38,
            ),
            const Padding(padding: EdgeInsets.only(left: 8.0)),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12.0),
                    )
                  ],
                )),
            SvgPicture.asset(
              'images/ic_syasarrow.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
            )
          ],
        )),
      ),
    );
  }
}
