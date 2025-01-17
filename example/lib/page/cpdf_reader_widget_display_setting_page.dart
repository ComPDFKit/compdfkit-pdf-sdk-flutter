/*
 * Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */

import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/util/extension/cpdf_color_extension.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

class CpdfReaderWidgetDisplaySettingPage extends StatefulWidget {
  final CPDFReaderWidgetController controller;

  const CpdfReaderWidgetDisplaySettingPage(
      {super.key, required this.controller});

  @override
  State<CpdfReaderWidgetDisplaySettingPage> createState() =>
      _CpdfReaderWidgetDisplaySettingPageState();
}

class _CpdfReaderWidgetDisplaySettingPageState
    extends State<CpdfReaderWidgetDisplaySettingPage> {
  bool _isVertical = true;

  CPDFDisplayMode _displayMode = CPDFDisplayMode.singlePage;

  bool _isLinkHighlight = true;

  bool _isFormFieldHighlight = true;

  bool _isContinuous = true;
  bool _isCrop = true;
  bool _canScale = true;
  CPDFThemes _themes = CPDFThemes.light;

  @override
  void initState() {
    super.initState();
    initReaderViewWidgetStates();
  }

  void initReaderViewWidgetStates() async {
    CPDFReaderWidgetController controller = widget.controller;
    bool isVer = await controller.isVerticalMode();
    bool isDoublePageMode = await controller.isDoublePageMode();
    bool isCoverPageMode = await controller.isCoverPageMode();
    bool isLinkHighlight = await controller.isLinkHighlight();
    bool isFormFieldHighlight = await controller.isFormFieldHighlight();
    bool isContinuous = await controller.isContinueMode();
    bool isCrop = await controller.isCropMode();
    Color themeColor = await controller.getReadBackgroundColor();
    debugPrint('themeColor: ${themeColor.toHex()}');
    setState(() {
      _isVertical = isVer;
      if (isDoublePageMode) {
        if (isCoverPageMode) {
          _displayMode = CPDFDisplayMode.coverPage;
        } else {
          _displayMode = CPDFDisplayMode.doublePage;
        }
      } else {
        _displayMode = CPDFDisplayMode.singlePage;
      }
      _isLinkHighlight = isLinkHighlight;
      _isFormFieldHighlight = isFormFieldHighlight;
      _isContinuous = isContinuous;
      _isCrop = isCrop;
      _themes = CPDFThemes.of(themeColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Column(children: [
        Container(
          margin: const EdgeInsets.only(left: 16),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 56,
          child: Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Expanded(child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _scrollItem(),
                _displayModeItem(),
                _otherItem(),
                _themesItem()
              ],
            ))),

      ],),
    );
  }

  Widget _scrollItem() {
    return Column(
      children: [
        _dividerLine('Scrolling'),
        _checkItem(
          'Vertical Scrolling',
          _isVertical,
          () async {
            await _updateVerticalMode(true);
          },
        ),
        _checkItem('Horizontal Scrolling', !_isVertical, () async {
          await _updateVerticalMode(false);
        })
      ],
    );
  }

  Future<void> _updateVerticalMode(bool isVertical) async {
    if (mounted) {
      setState(() {
        _isVertical = isVertical;
      });
    }
    await widget.controller.setVerticalMode(isVertical);
  }

  Widget _displayModeItem() {
    return Column(
      children: [
        _dividerLine('Display Mode'),
        _checkItem(
          'Single Page',
          _displayMode == CPDFDisplayMode.singlePage,
          () async {
            await _updateDisplayMode(CPDFDisplayMode.singlePage);
          },
        ),
        _checkItem('Two Page', _displayMode == CPDFDisplayMode.doublePage,
            () async {
          await _updateDisplayMode(CPDFDisplayMode.doublePage);
        }),
        _checkItem('Cover Mode', _displayMode == CPDFDisplayMode.coverPage,
            () async {
          await _updateDisplayMode(CPDFDisplayMode.coverPage);
        })
      ],
    );
  }

  Future<void> _updateDisplayMode(CPDFDisplayMode displayMode) async {
    if (mounted) {
      setState(() {
        _displayMode = displayMode;
      });
    }
    if (displayMode == CPDFDisplayMode.singlePage) {
      await widget.controller.setDoublePageMode(false);
    } else if (displayMode == CPDFDisplayMode.doublePage) {
      await widget.controller.setDoublePageMode(true);
    } else {
      await widget.controller.setCoverPageMode(true);
    }
  }

  Widget _otherItem() {
    return Column(
      children: [
        _dividerLine(''),
        _switchItem('Highlight Links', _isLinkHighlight, (check) async {
          setState(() {
            _isLinkHighlight = check;
          });
          await widget.controller.setLinkHighlight(check);
        }),
        _switchItem('Highlight Form Fields', _isFormFieldHighlight,
            (check) async {
          setState(() {
            _isFormFieldHighlight = check;
          });
          await widget.controller.setFormFieldHighlight(check);
        }),
        _switchItem('Continuous Scrolling', _isContinuous, (check) async {
          setState(() {
            _isContinuous = check;
          });
          await widget.controller.setContinueMode(check);
        }),
        _switchItem('Crop', _isCrop, (check) async {
          setState(() {
            _isCrop = check;
          });
          await widget.controller.setCropMode(check);
        }),
        if (Platform.isAndroid) ...{
          _switchItem('Can Scale', _canScale, (check) async {
            setState(() {
              _canScale = check;
            });
            await widget.controller.setCanScale(check);
          }),
        }
      ],
    );
  }

  Widget _themesItem() {
    return Column(
      children: [
        _dividerLine('Themes'),
        _checkItem('Light', _themes == CPDFThemes.light, () async {
          await _updateTheme(CPDFThemes.light);
        }),
        _checkItem('Dark', _themes == CPDFThemes.dark, () async {
          await _updateTheme(CPDFThemes.dark);
        }),
        _checkItem('Sepia', _themes == CPDFThemes.sepia, () async {
          await _updateTheme(CPDFThemes.sepia);
        }),
        _checkItem('Reseda', _themes == CPDFThemes.reseda, () async {
          await _updateTheme(CPDFThemes.reseda);
        })
      ],
    );
  }

  Future<void> _updateTheme(CPDFThemes themes) async {
    if (mounted) {
      setState(() {
        _themes = themes;
      });
    }
    await widget.controller.setReadBackgroundColor(themes);
  }

  Widget _dividerLine(String title) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).appBarTheme.backgroundColor),
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w500)),
    );
  }

  Widget _checkItem(String title, bool isCheck, GestureTapCallback onTap) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: isCheck
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
    );
  }

  Widget _switchItem(String title, bool isCheck, ValueChanged<bool> changed) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: Transform.scale(
        scale: 0.8,
        child: Switch(value: isCheck, onChanged: changed),
      ),
    );
  }
}
