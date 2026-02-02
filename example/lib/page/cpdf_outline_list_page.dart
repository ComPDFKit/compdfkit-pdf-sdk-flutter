/*
 * Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
 *
 * THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
 * AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
 * UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
 * This notice may not be removed from this file.
 *
 */
import 'dart:convert';

import 'package:compdfkit_flutter/document/cpdf_document.dart';
import 'package:compdfkit_flutter/document/cpdf_outline.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:flutter/material.dart';

// dart
class _FlatNode {
  final CPDFOutline node;
  final CPDFOutline? parent;

  _FlatNode(this.node, this.parent);
}

class CPDFOutlineListPage extends StatefulWidget {
  final CPDFDocument document;

  const CPDFOutlineListPage({super.key, required this.document});

  @override
  State<CPDFOutlineListPage> createState() => _CpdfOutlineListPageState();
}

class _CpdfOutlineListPageState extends State<CPDFOutlineListPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _pageIndexTextEditingController =
      TextEditingController();

  CPDFOutline? _rootOutline;
  List<CPDFOutline> _rootOutlines = [];
  final Set<String> _expanded = {};
  bool _loading = false;
  bool _error = false;

  CPDFOutline? _needMoveOutline;

  @override
  void initState() {
    super.initState();
    _loadOutlines();
  }

  Future<void> _loadOutlines() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final rootOutline = await widget.document.getOutlineRoot();
      _rootOutline = rootOutline;
      printJsonString(jsonEncode(_rootOutline));
      _rootOutlines = rootOutline?.childList ?? [];
      // printJsonString(jsonEncode(_rootOutlines));
    } catch (e) {
      _error = true;
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  List<_FlatNode> _flatten() {
    final result = <_FlatNode>[];
    void walk(List<CPDFOutline> nodes, CPDFOutline? parent) {
      for (final n in nodes) {
        result.add(_FlatNode(n, parent));
        if (_expanded.contains(n.uuid) && n.childList.isNotEmpty) {
          walk(n.childList, n);
        }
      }
    }

    walk(_rootOutlines, null);
    return result;
  }

  void _toggleExpand(CPDFOutline node) {
    if (node.childList.isEmpty) return;
    setState(() {
      if (_expanded.contains(node.uuid)) {
        _expanded.remove(node.uuid);
      } else {
        _expanded.add(node.uuid);
      }
    });
  }

  void _onDelete(CPDFOutline node) async {
    bool result = await widget.document.removeOutline(node.uuid);
    if (result) {
      await _loadOutlines();
    }
    setState(() {
      _expanded.remove(node.uuid);
    });
  }

  void _onAdd(
    CPDFOutline parent, {
    String title = 'New Outline',
    int pageIndex = 0,
  }) async {
    bool result = await widget.document.addOutline(
        parentUuid: parent.uuid, title: title, pageIndex: pageIndex);
    if (result) {
      await _loadOutlines();
    }
    setState(() {
      _expanded.add(parent.uuid);
    });
  }

  void _onUpdate(CPDFOutline outline, String newTitle, int pageIndex) async {
    bool result = await widget.document.updateOutline(
        uuid: outline.uuid, title: newTitle, pageIndex: pageIndex);
    if (result) {
      await _loadOutlines();
    }
  }

  Widget _buildRow(_FlatNode flat) {
    final node = flat.node;
    final hasChildren = node.childList.isNotEmpty;
    final expanded = _expanded.contains(node.uuid);
    return InkWell(
      onTap: () async {
        if (_needMoveOutline != null) {
          bool result = await widget.document.moveOutline(
              newParent: node, outline: _needMoveOutline!, insertIndex: -1);
          debugPrint('ComPDFKit-Flutter: moveTo:$result');
          _loadOutlines();
          setState(() {
            _needMoveOutline = null;
          });
        } else {
          Navigator.pop(context, node.destination?.pageIndex);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        child: Row(
          children: [
            SizedBox(width: node.level * 8.0),
            if (hasChildren)
              IconButton(
                  onPressed: () => _toggleExpand(node),
                  icon: Icon(
                    expanded ? Icons.expand_more : Icons.chevron_right,
                    size: 18,
                  ))
            else
              const SizedBox(width: 48),
            const SizedBox(width: 4),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  node.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Page Index: ${node.destination?.pageIndex ?? 0}',
                  maxLines: 1,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            )),
            IconButton(
              tooltip: 'Update Outline',
              icon: const Icon(Icons.edit, size: 20, color: Colors.green),
              onPressed: () async {
                Map<String, dynamic>? map = await _showAddRootOutlineDialog(
                    title: 'Add Outline',
                    content: node.title,
                    pageIndex: node.destination?.pageIndex ?? 0);
                if (map != null) {
                  String title = map['title'] ?? 'New Outline';
                  int pageIndex = map['pageIndex'] ?? 0;
                  _onUpdate(node, title, pageIndex);
                }
              },
            ),
            IconButton(
              tooltip: 'Add Child',
              icon: const Icon(Icons.add, size: 20, color: Colors.green),
              onPressed: () => _onAdd(node),
            ),
            IconButton(
              tooltip: 'Move',
              icon: const Icon(Icons.move_down, size: 20, color: Colors.green),
              onPressed: () {
                setState(() {
                  _needMoveOutline = node;
                });
                // _onDelete(node);
              },
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () {
                _onDelete(node);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flat = _flatten();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outlines'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loadOutlines,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? Center(
                  child: TextButton(
                    onPressed: _loadOutlines,
                    child: const Text('Load Outlines Failed. Tap to Retry.'),
                  ),
                )
              : flat.isEmpty
                  ? const Center(child: Text('Not Found Outlines'))
                  : ListView.builder(
                      itemCount: flat.length,
                      itemBuilder: (_, i) => _buildRow(flat[i]),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic>? map =
              await _showAddRootOutlineDialog(title: 'Add Outline');
          if (map != null) {
            String title = map['title'] ?? 'New Outline';
            int pageIndex = map['pageIndex'] ?? 0;
            if(_rootOutline != null){
              _onAdd(_rootOutline!, title: title, pageIndex: pageIndex);
            } else {
              final outlineRoot = await widget.document.newOutlineRoot();
              if(outlineRoot != null) {
                debugPrint('ComPDFKit-Flutter: create outline root success');
                _rootOutline = outlineRoot;
                _onAdd(_rootOutline!, title: title, pageIndex: pageIndex);
              }
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<Map<String, dynamic>?> _showAddRootOutlineDialog({
    String title = 'Add Outline',
    String content = '',
    int pageIndex = 0,
  }) async {
    _textEditingController.text = content;
    _pageIndexTextEditingController.text = '$pageIndex';
    return await showDialog<Map<String, dynamic>?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  onChanged: (value) {
                    // Store the input value
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pageIndexTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Page Index',
                  ),
                  onChanged: (value) {
                    // Store the input value
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Call _onAdd with the input title
                  Navigator.of(context).pop({
                    'title': _textEditingController.text,
                    'pageIndex':
                        int.tryParse(_pageIndexTextEditingController.text) ?? 0,
                  });
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _pageIndexTextEditingController.dispose();
    super.dispose();
  }
}
