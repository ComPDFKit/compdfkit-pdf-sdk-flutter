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

import '../../constants/asset_paths.dart';
import '../../widgets/app_toolbar.dart';

final Map<CPDFStandardStamp, String> standardStampMap = {
  CPDFStandardStamp.approved: AppAssets.stampApproved,
  CPDFStandardStamp.notApproved: AppAssets.stampNotApproved,
  CPDFStandardStamp.draft: AppAssets.stampDraft,
  CPDFStandardStamp.final_: AppAssets.stampFinal,
  CPDFStandardStamp.completed: AppAssets.stampCompleted,
  CPDFStandardStamp.confidential: AppAssets.stampConfidential,
  CPDFStandardStamp.forPublicRelease: AppAssets.stampForPublicRelease,
  CPDFStandardStamp.notForPublicRelease: AppAssets.stampNotForPublicRelease,
  CPDFStandardStamp.forComment: AppAssets.stampForComment,
  CPDFStandardStamp.void_: AppAssets.stampVoid,
  CPDFStandardStamp.preliminaryResults: AppAssets.stampPreliminaryResults,
  CPDFStandardStamp.informationOnly: AppAssets.stampInformationOnly,
  CPDFStandardStamp.witness: AppAssets.stampWitness,
  CPDFStandardStamp.initialHere: AppAssets.stampInitialHere,
  CPDFStandardStamp.signHere: AppAssets.stampSignHere,
  CPDFStandardStamp.revised: AppAssets.stampRevised,
  CPDFStandardStamp.accepted: AppAssets.stampAccepted,
  CPDFStandardStamp.rejected: AppAssets.stampRejected,
  CPDFStandardStamp.privateAccepted: AppAssets.stampPrivateAccepted,
  CPDFStandardStamp.privateRejected: AppAssets.stampPrivateRejected,
  CPDFStandardStamp.privateRadioMark: AppAssets.stampPrivateRadioMark,
};

class StampListPage extends StatefulWidget {
  const StampListPage({super.key});

  @override
  State<StampListPage> createState() => _StampListPageState();
}

class _StampListPageState extends State<StampListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<_StampData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dataFuture = _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<_StampData> _loadData() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final allAssets = manifest.listAssets();
    final customAssets = allAssets
        .where((p) => p.startsWith(AppAssets.signPrefix))
        .toList()
      ..sort();

    final List<_StandardStampItem> standardItems = [];
    for (var entry in standardStampMap.entries) {
      standardItems.add(_StandardStampItem(
        stamp: entry.key,
        assetPath: entry.value,
      ));
    }
    return _StampData(standard: standardItems, custom: customAssets);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: AppToolbar(
            title: 'Stamp List',
            onBack: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(3),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withAlpha(20),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: colorScheme.onSurface,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: textTheme.labelLarge,
              unselectedLabelStyle: textTheme.bodyMedium,
              tabs: const [
                Tab(text: 'Standard'),
                Tab(text: 'Custom'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<_StampData>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                      strokeWidth: 2.5,
                    ),
                  );
                }
                final data = snapshot.data!;
                return TabBarView(
                  controller: _tabController,
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
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStampGrid({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.7,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  Widget _buildStampCard({
    required Widget child,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStandardList(List<_StandardStampItem> items) {
    if (items.isEmpty) {
      return _buildEmptyState(
        icon: Icons.image_not_supported_outlined,
        title: 'No Standard Stamps',
        subtitle: 'Standard stamp resources are not available',
      );
    }
    return _buildStampGrid(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildStampCard(
          onTap: () => Navigator.pop(context, {
            'type': CPDFStampType.standard,
            'standardStamp': item.stamp,
          }),
          child: Image.asset(item.assetPath, fit: BoxFit.contain),
        );
      },
    );
  }

  Widget _buildCustomList(List<String> assets) {
    if (assets.isEmpty) {
      return _buildEmptyState(
        icon: Icons.brush_outlined,
        title: 'No Custom Stamps',
        subtitle: 'Add custom stamp images to get started',
      );
    }
    return _buildStampGrid(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final path = assets[index];
        return _buildStampCard(
          onTap: () async {
            final navigator = Navigator.of(context);
            final imageFile = await CPDFFileUtil.extractAsset(path);
            if (!mounted) return;
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
