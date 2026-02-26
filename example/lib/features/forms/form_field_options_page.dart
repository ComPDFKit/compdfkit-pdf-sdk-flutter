import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget_item.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter_example/widgets/app_toolbar.dart';
import 'package:flutter/material.dart';

/// Options list page for list/combo box widgets.
///
/// Allows adding and removing options, then persists changes to the document.
class FormFieldOptionsPage extends StatefulWidget {
  final CPDFDocument document;

  final CPDFWidget cpdfWidget;

  const FormFieldOptionsPage(
      {super.key, required this.document, required this.cpdfWidget});

  @override
  State<FormFieldOptionsPage> createState() => _FormFieldOptionsPageState();
}

class _FormFieldOptionsPageState extends State<FormFieldOptionsPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<CPDFWidgetItem> _options = [];

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  void _loadOptions() {
    final loaded = _readOptions();
    setState(() {
      _options
        ..clear()
        ..addAll(loaded);
    });
  }

  List<CPDFWidgetItem> _readOptions() {
    if (widget.cpdfWidget is CPDFListBoxWidget) {
      final listBox = widget.cpdfWidget as CPDFListBoxWidget;
      return listBox.options ?? [];
    }
    if (widget.cpdfWidget is CPDFComboBoxWidget) {
      final comboBox = widget.cpdfWidget as CPDFComboBoxWidget;
      return comboBox.options ?? [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: 'Options List',
            onBack: () => Navigator.pop(context),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        itemCount: _options.length,
        itemBuilder: (context, index) => _buildOptionTile(context, index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddOption,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final item = _options[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.format_list_bulleted_rounded,
                    size: 18,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.value,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.text != item.value)
                        Text(
                          item.text,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _handleDeleteOption(index),
                  icon: Icon(
                    Icons.delete_outline,
                    color: colorScheme.error,
                  ),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAddOption() async {
    _textEditingController.clear();
    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: 'Enter option text',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_textEditingController.text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (value != null && value.isNotEmpty) {
      setState(() {
        _options.add(CPDFWidgetItem(text: value, value: value));
      });
      await _updateOptions();
    }
  }

  Future<void> _updateOptions() async {
    if (widget.cpdfWidget is CPDFListBoxWidget) {
      final listBox = widget.cpdfWidget as CPDFListBoxWidget;
      listBox.options = _options;
    } else if (widget.cpdfWidget is CPDFComboBoxWidget) {
      final comboBox = widget.cpdfWidget as CPDFComboBoxWidget;
      comboBox.options = _options;
    }
    await widget.document.updateWidget(widget.cpdfWidget);
  }

  void _handleDeleteOption(int index) async {
    setState(() {
      _options.removeAt(index);
    });
    await _updateOptions();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
