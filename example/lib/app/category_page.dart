// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

import '../examples/registry.dart';
import '../utils/platform_capability.dart';
import '../widgets/app_toolbar.dart';

/// Category Page
class CategoryPage extends StatelessWidget {
  /// Category information
  final CategoryInfo category;

  /// Constructor
  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final examples = category.examples;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppToolbar(
              title: category.name,
              subtitle: category.description,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  itemCount: examples.length + 1,
                  separatorBuilder: (_, index) {
                    if (index == 0) {
                      return const SizedBox(height: 8);
                    }
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final textTheme = Theme.of(context).textTheme;
                      final colorScheme = Theme.of(context).colorScheme;
                      return Text(
                        'Examples',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    }
                    final example = examples[index - 1];
                    final supportsPlatform =
                        example.supportedPlatforms == null ||
                            example.supportedPlatforms!.contains(platform);
                    final isEnabled =
                        PlatformCapability.supportsExampleCatalog &&
                            supportsPlatform;
                    return _ExampleTile(
                      category: category,
                      example: example,
                      index: index - 1,
                      isEnabled: isEnabled,
                      onTap: () {
                        if (example.routeType == ExampleRouteType.pageBuilder) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: example.pageBuilder!,
                            ),
                          );
                        } else {
                          example.modalCallback!(context);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleTile extends StatelessWidget {
  final CategoryInfo category;
  final ExampleItem example;
  final int index;
  final bool isEnabled;
  final VoidCallback onTap;

  const _ExampleTile({
    required this.category,
    required this.example,
    required this.index,
    required this.isEnabled,
    required this.onTap,
  });

  _ExampleVisualConfig _resolveVisual(ColorScheme scheme) {
    // ==================== Use custom visual configuration ====================
    if (example.visual != null) {
      return _ExampleVisualConfig(
        icon: example.visual!.icon ?? category.icon,
        backgroundColor: example.visual!.backgroundColor ??
            _getDefaultBackgroundColor(scheme, 0),
        iconColor: example.visual!.iconColor ?? _getDefaultIconColor(scheme, 0),
      );
    }

    // ==================== Use category icon + cyclic coloring ====================
    return _ExampleVisualConfig(
      icon: category.icon,
      backgroundColor: _getDefaultBackgroundColor(scheme, index),
      iconColor: _getDefaultIconColor(scheme, index),
    );
  }

  Color _getDefaultBackgroundColor(ColorScheme scheme, int index) {
    final backgrounds = [
      scheme.tertiaryContainer,
      scheme.primaryContainer,
      scheme.secondaryContainer,
      scheme.surfaceContainerHighest,
    ];
    return backgrounds[index % backgrounds.length];
  }

  Color _getDefaultIconColor(ColorScheme scheme, int index) {
    final iconColors = [
      scheme.tertiary,
      scheme.primary,
      scheme.secondary,
      scheme.onSurfaceVariant,
    ];
    return iconColors[index % iconColors.length];
  }

  List<Widget> _buildPlatformChips(BuildContext context) {
    final platforms = example.supportedPlatforms;
    if (platforms == null || platforms.isEmpty) {
      return const [];
    }
    return platforms.map((platform) {
      final label = switch (platform) {
        TargetPlatform.android => 'Android',
        TargetPlatform.iOS => 'iOS',
        TargetPlatform.fuchsia => 'Fuchsia',
        TargetPlatform.linux => 'Linux',
        TargetPlatform.macOS => 'macOS',
        TargetPlatform.windows => 'Windows',
      };
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }).toList();
  }

  Widget? _buildTrailing(BuildContext context) {
    if (!isEnabled) {
      final colorScheme = Theme.of(context).colorScheme;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          PlatformCapability.isWeb ? 'Mobile only' : 'Unsupported',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }
    if (example.routeType == ExampleRouteType.modalCallback) {
      final colorScheme = Theme.of(context).colorScheme;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'MODAL',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onPrimary,
              ),
        ),
      );
    }
    final chips = _buildPlatformChips(context);
    if (chips.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...chips,
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final visual = _resolveVisual(colorScheme);
    final trailing = _buildTrailing(context);
    return Material(
      color: isEnabled
          ? colorScheme.surface
          : colorScheme.surface.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 72,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: visual.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    visual.icon,
                    size: 20,
                    color: visual.iconColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        example.title,
                        style: textTheme.bodyMedium?.copyWith(
                          color: isEnabled
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (example.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          example.description!,
                          style: textTheme.bodySmall?.copyWith(
                            color: isEnabled
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExampleVisualConfig {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _ExampleVisualConfig({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}
