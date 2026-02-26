/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

import '../../annotations/tools/annotation_history_toolbar.dart';

class FormToolbar extends StatefulWidget {
  final CPDFReaderWidgetController controller;
  final List<CPDFFormType> availableFormTypes;

  const FormToolbar({
    super.key,
    required this.controller,
    this.availableFormTypes = CPDFFormType.values,
  });

  @override
  State<FormToolbar> createState() => _FormToolbarState();
}

class _FormToolbarState extends State<FormToolbar> {
  static const Color _toolbarBackground = Color(0xFFFAFCFF);
  static const Color _activeBackground = Color(0xFFDDE9FF);
  static const Color _activeIconColor = Color(0xFF34367C);
  static const Color _idleIconColor = Color(0xFF43474D);

  CPDFFormType _selectedType = CPDFFormType.unknown;

  List<_FormToolItem> get _items => _defaultItems
      .where((item) => widget.availableFormTypes.contains(item.type))
      .toList(growable: false);

  @override
  void initState() {
    super.initState();
    _loadInitialMode();
  }

  Future<void> _loadInitialMode() async {
    final mode = await widget.controller.getFormCreationMode();
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedType = mode;
    });
  }

  Future<void> _selectType(CPDFFormType type) async {
    final nextType = _selectedType == type ? CPDFFormType.unknown : type;
    setState(() {
      _selectedType = nextType;
    });
    await widget.controller.setFormCreationMode(nextType);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      color: _toolbarBackground,
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _items
                      .map((item) => _FormToolButton(
                            item: item,
                            isActive: _selectedType == item.type,
                            onTap: () => _selectType(item.type),
                          ))
                      .toList(growable: false),
                ),
              ),
            ),
          ),
          AnnotationHistoryToolbar(controller: widget.controller),
        ],
      ),
    );
  }
}

class _FormToolButton extends StatelessWidget {
  final _FormToolItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _FormToolButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background =
        isActive ? _FormToolbarState._activeBackground : Colors.transparent;
    final iconColor = isActive
        ? _FormToolbarState._activeIconColor
        : _FormToolbarState._idleIconColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Tooltip(
        message: item.label,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: 48,
              height: 40,
              child: Center(
                child: Icon(item.icon, color: iconColor, size: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormToolItem {
  final CPDFFormType type;
  final IconData icon;
  final String label;

  const _FormToolItem({
    required this.type,
    required this.icon,
    required this.label,
  });
}

const List<_FormToolItem> _defaultItems = [
  _FormToolItem(
    type: CPDFFormType.textField,
    icon: Icons.text_fields,
    label: 'Text Field',
  ),
  _FormToolItem(
    type: CPDFFormType.checkBox,
    icon: Icons.check_box_outlined,
    label: 'Checkbox',
  ),
  _FormToolItem(
    type: CPDFFormType.radioButton,
    icon: Icons.radio_button_checked,
    label: 'Radio Button',
  ),
  _FormToolItem(
    type: CPDFFormType.listBox,
    icon: Icons.list_alt,
    label: 'List Box',
  ),
  _FormToolItem(
    type: CPDFFormType.comboBox,
    icon: Icons.arrow_drop_down_circle_outlined,
    label: 'Combo Box',
  ),
  _FormToolItem(
    type: CPDFFormType.signaturesFields,
    icon: Icons.draw_outlined,
    label: 'Signature',
  ),
  _FormToolItem(
    type: CPDFFormType.pushButton,
    icon: Icons.smart_button_outlined,
    label: 'Button',
  ),
];
