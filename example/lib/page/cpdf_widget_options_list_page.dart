import 'package:compdfkit_flutter/annotation/form/cpdf_combobox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_listbox_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget.dart';
import 'package:compdfkit_flutter/annotation/form/cpdf_widget_item.dart';
import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:flutter/material.dart';

class CPDFWidgetOptionsListPage extends StatefulWidget {
  final CPDFDocument document;

  final CPDFWidget cpdfWidget;

  const CPDFWidgetOptionsListPage(
      {super.key, required this.document, required this.cpdfWidget});

  @override
  State<CPDFWidgetOptionsListPage> createState() =>
      _CpdfWidgetOptionsListPageState();
}

class _CpdfWidgetOptionsListPageState extends State<CPDFWidgetOptionsListPage> {
  final TextEditingController textEditingController = TextEditingController();

  List<CPDFWidgetItem> options = [];

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  void _loadOptions() {
    setState(() {
      if(widget.cpdfWidget is CPDFListBoxWidget){
        final listBox = widget.cpdfWidget as CPDFListBoxWidget;
        options = listBox.options ?? [];
      } else if(widget.cpdfWidget is CPDFComboBoxWidget){
        final comboBox = widget.cpdfWidget as CPDFComboBoxWidget;
        options = comboBox.options ?? [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options List'),
      ),
      body: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            final item = options[index];
            return ListTile(
              title: Text(item.value),
              leading: const Icon(Icons.menu),
              trailing: IconButton(
                  onPressed: () {
                    _handleDeleteOption(index);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _handleAddOption();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleAddOption() async {
    textEditingController.clear();
    String? value = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Item'),
            content: TextField(
              controller: textEditingController,
            ),
            actions: [
              TextButton(onPressed: () {}, child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(textEditingController.text);
                  },
                  child: const Text('Add')),
            ],
          );
        });

    if (value != null && value.isNotEmpty) {
      setState(() {
        options.add(CPDFWidgetItem(text: value, value: value));
      });
      _updateOptions();
      await widget.document.updateWidget(widget.cpdfWidget);
    }
  }

  void _updateOptions() async {
    if(widget.cpdfWidget is CPDFListBoxWidget){
      final listBox = widget.cpdfWidget as CPDFListBoxWidget;
      listBox.options = options;
    } else if(widget.cpdfWidget is CPDFComboBoxWidget){
      final comboBox = widget.cpdfWidget as CPDFComboBoxWidget;
      comboBox.options = options;
    }
    await widget.document.updateWidget(widget.cpdfWidget);
  }

  void _handleDeleteOption(int index) async {
    setState(() {
      options.removeAt(index);
    });
    _updateOptions();
    await widget.document.updateWidget(widget.cpdfWidget);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
