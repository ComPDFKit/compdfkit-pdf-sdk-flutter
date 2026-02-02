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

import 'package:flutter/services.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';


final Map<CPDFStandardStamp, String> standardStampMap = {
    CPDFStandardStamp.approved: 'images/stamp/stamp_approved.png',
    CPDFStandardStamp.notApproved: 'images/stamp/stamp_not_approved.png',
    CPDFStandardStamp.draft: 'images/stamp/stamp_draft.png',
    CPDFStandardStamp.final_: 'images/stamp/stamp_final.png',
    CPDFStandardStamp.completed: 'images/stamp/stamp_completed.png',
    CPDFStandardStamp.confidential: 'images/stamp/stamp_confidential.png',
    CPDFStandardStamp.forPublicRelease: 'images/stamp/stamp_for_public_release.png',
    CPDFStandardStamp.notForPublicRelease: 'images/stamp/stamp_not_for_public_release.png',
    CPDFStandardStamp.forComment: 'images/stamp/stamp_for_comment.png',
    CPDFStandardStamp.void_: 'images/stamp/stamp_void.png',
    CPDFStandardStamp.preliminaryResults: 'images/stamp/stamp_preliminary_results.png',
    CPDFStandardStamp.informationOnly: 'images/stamp/stamp_information_only.png',
    CPDFStandardStamp.witness: 'images/stamp/stamp_witness.png',
    CPDFStandardStamp.initialHere: 'images/stamp/stamp_initial_here.png',
    CPDFStandardStamp.signHere: 'images/stamp/stamp_sign_here.png',
    CPDFStandardStamp.revised: 'images/stamp/stamp_revised.png',
    CPDFStandardStamp.accepted: 'images/stamp/stamp_accepted.png',
    CPDFStandardStamp.rejected: 'images/stamp/stamp_rejected.png',
    CPDFStandardStamp.privateAccepted: 'images/stamp/stamp_private_accepted.png',
    CPDFStandardStamp.privateRejected: 'images/stamp/stamp_private_rejected.png',
    CPDFStandardStamp.privateRadioMark: 'images/stamp/stamp_private_radio_mark.png',
  };

class CPDFStampListPage extends StatefulWidget {
  const CPDFStampListPage({super.key});

  @override
  State<CPDFStampListPage> createState() => _CPDFStampListPageState();
}

class _CPDFStampListPageState extends State<CPDFStampListPage>
    with SingleTickerProviderStateMixin {
  late Future<_StampData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<_StampData> _loadData() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final allAssets = manifest.listAssets();
    final customAssets = allAssets
        .where((p) => p.startsWith('images/sign/'))
        .toList()
      ..sort();

    final List<_StandardStampItem> standardItems = [];
    for (var entry in standardStampMap.entries) {
      final stamp = entry.key;
      final path = entry.value;
      standardItems.add(_StandardStampItem(stamp: stamp, assetPath: path));
    }
    return _StampData(
      standard: standardItems,
      custom: customAssets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stamp List'),),
      body: DefaultTabController(
        length: 2,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Standard Stamp'),
                  Tab(text: 'Custom Stamp'),
                ],
              ),
              Expanded(
                child: FutureBuilder<_StampData>(
                  future: _dataFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data!;
                    return TabBarView(
                      children: [
                        _buildStandardList(data.standard),
                        _buildCustomList(data.custom),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandardList(List<_StandardStampItem> items) {
    if (items.isEmpty) {
      return const Center(child: Text('not found standard stamp resources'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () => Navigator.pop(context, {
            'type': CPDFStampType.standard,
            'standardStamp': item.stamp,
          }),
          child: Padding(padding: const EdgeInsets.all(8), child:  Image.asset(item.assetPath)),
        );
      },
    );
  }

  Widget _buildCustomList(List<String> assets) {
    if (assets.isEmpty) {
      return const Center(child: Text('not found custom stamp resources'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.7,
      ),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final path = assets[index];
        return InkWell(
          onTap: () async {
            final navigator = Navigator.of(context);
            final imageFile = await CPDFFileUtil.extractAsset(path);
            if (!mounted) {
              return;
            }
            navigator.pop({
              'type': CPDFStampType.image,
              'imagePath': imageFile.path,
            });
          },
          child: Image.asset(path, fit: BoxFit.contain),
        );
      },
    );
  }
}

class _StampData {
  final List<_StandardStampItem> standard;
  final List<String> custom;
  _StampData({required this.standard, required this.custom});
}

class _StandardStampItem {
  final CPDFStandardStamp stamp;
  final String assetPath;
  _StandardStampItem({required this.stamp, required this.assetPath});
}
