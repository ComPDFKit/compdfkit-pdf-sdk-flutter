/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:flutter/material.dart';

class CpdfReaderWidgetSwitchPreviewModePage extends StatefulWidget {
  final CPDFViewMode viewMode;

  const CpdfReaderWidgetSwitchPreviewModePage(
      {super.key, required this.viewMode});

  @override
  State<CpdfReaderWidgetSwitchPreviewModePage> createState() =>
      _CpdfReaderWidgetSwitchPreviewModePageState();
}

class _CpdfReaderWidgetSwitchPreviewModePageState
    extends State<CpdfReaderWidgetSwitchPreviewModePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.labelLarge;
    return SizedBox(
        height: 336,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text('Mode', style: Theme.of(context).textTheme.titleMedium),
                  Positioned(
                      right: 16,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)))
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: CPDFViewMode.values.length,
                    itemBuilder: (context, index) {
                      CPDFViewMode mode = CPDFViewMode.values[index];
                      return ListTile(
                          onTap: () async {
                            Navigator.pop(context, mode);
                          },
                          title: Text(mode.name, style: textStyle),
                          trailing: widget.viewMode == mode
                              ? const Icon(Icons.check)
                              : null);
                    }))
          ],
        ));
  }
}
