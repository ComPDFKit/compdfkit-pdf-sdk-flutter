import 'package:flutter/material.dart';

/// Quick swipe bar control for CPDFReaderWidget
/// version: v1.1
/// example:
/// ```dart
/// // vertical scroll
/// CPDFReaderSliderBar(
///     thumbColor: Colors.green,
///     showPageIndicator: false,
///     currentPage: _currentPage,
///     pageCount: _pageCount,
///     axis: Axis.vertical,
///     onJumpToPage: (page) {
///     _controller?.setDisplayPageIndex(page);
///     setState(() => _currentPage = page);
///     }
/// )
///
/// // horizontal scroll
/// CPDFReaderSliderBar(
///     thumbColor: Colors.green,
///     showPageIndicator: false,
///     currentPage: _currentPage,
///     pageCount: _pageCount,
///     axis: Axis.horizontal,
///     onJumpToPage: (page) {
///     _controller?.setDisplayPageIndex(page);
///     setState(() => _currentPage = page);
///     }
/// )
/// ```

class CPDFReaderSliderBar extends StatefulWidget {

  final int currentPage;

  final int pageCount;

  final void Function(int page, bool isFinal) onJumpToPage;

  final double thumbHeight;

  final bool showPageIndicator;

  final Color thumbColor;

  final Widget Function(bool isDragging)? thumbBuilder;

  final Axis axis;

  const CPDFReaderSliderBar({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.onJumpToPage,
    this.thumbHeight = 40.0,
    this.showPageIndicator = true,
    this.thumbBuilder,
    this.axis = Axis.vertical,
    this.thumbColor = Colors.blue
  });

  @override
  State<CPDFReaderSliderBar> createState() => _CpdfReaderSliderBarState();
}

class _CpdfReaderSliderBarState extends State<CPDFReaderSliderBar> {
  bool _isDragging = false;
  double? _dragPosition;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVertical = widget.axis == Axis.vertical;
        final totalLength = isVertical ? constraints.maxHeight : constraints.maxWidth;
        final thumbSize = widget.thumbHeight;

        final thumbOffset = _dragPosition ??
            ((widget.pageCount <= 1)
                ? 0.0
                : (widget.currentPage / (widget.pageCount - 1)) *
                (totalLength - thumbSize));

        return Listener(
          onPointerMove: (event) => _handlePointerEvent(event, totalLength, isVertical, isFinal: false),
          onPointerUp: (event) => _handlePointerEvent(event, totalLength, isVertical, isFinal: true),
          child: GestureDetector(
            onVerticalDragStart: isVertical ? (_) => _setDragging(true) : null,
            onVerticalDragEnd: isVertical ? (_) => _setDragging(false) : null,
            onHorizontalDragStart: !isVertical ? (_) => _setDragging(true) : null,
            onHorizontalDragEnd: !isVertical ? (_) => _setDragging(false) : null,
            child: Stack(
              children: [
                if (_isDragging &&
                    _dragPosition != null &&
                    widget.showPageIndicator)
                  Positioned(
                    top: isVertical ? thumbOffset - 30 : null,
                    left: !isVertical ? thumbOffset - 30 : null,
                    right: null,
                    bottom: null,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(178),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${((_dragPosition! / (totalLength - thumbSize)) * (widget.pageCount - 1)).round() + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),

                AnimatedPositioned(
                  duration: _isDragging
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  curve: Curves.linear,
                  top: isVertical ? thumbOffset : null,
                  left: !isVertical ? thumbOffset : null,
                  right: null,
                  bottom: null,
                  child: _buildThumb(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _setDragging(bool dragging) {
    setState(() => _isDragging = dragging);
    if (!dragging) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() => _dragPosition = null);
        }
      });
    }
  }

  void _handlePointerEvent(PointerEvent event, double totalLength, bool isVertical, {required bool isFinal}) {
    final box = context.findRenderObject() as RenderBox;
    final localOffset = box.globalToLocal(event.position);
    final localPos = (isVertical ? localOffset.dy : localOffset.dx)
        .clamp(0.0, totalLength - widget.thumbHeight);

    setState(() => _dragPosition = localPos);

    final relative = localPos / (totalLength - widget.thumbHeight);
    final targetPage = (relative * (widget.pageCount - 1)).round();

    if (targetPage != widget.currentPage) {
      widget.onJumpToPage(targetPage, isFinal);
    }
  }

  Widget _buildThumb() {
    if (widget.thumbBuilder != null) {
      return widget.thumbBuilder!(_isDragging);
    }
    return Center(
      child: Container(
        height: widget.axis == Axis.vertical ? widget.thumbHeight : 22,
        width: widget.axis == Axis.vertical ? 22 : widget.thumbHeight,
        decoration: BoxDecoration(
          color: widget.thumbColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (_isDragging)
              BoxShadow(
                color: Colors.blue.withAlpha(78),
                blurRadius: 6,
                spreadRadius: 2,
              ),
          ],
        ),
        child: const Icon(Icons.drag_handle, color: Colors.white, size: 20),
      ),
    );
  }
}