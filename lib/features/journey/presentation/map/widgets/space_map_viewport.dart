import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sirah_app/features/journey/presentation/map/widgets/space_map_controls.dart';

class SpaceMapViewport extends StatefulWidget {
  const SpaceMapViewport({
    super.key,
    required this.mapSize,
    required this.child,
    this.initialScale,
    this.minScale = 0.4,
    this.maxScale = 2.4,
    this.viewPadding = EdgeInsets.zero,
    this.controlsPadding = const EdgeInsets.only(top: 12, right: 12),
  });

  final Size mapSize;
  final Widget child;
  final double? initialScale;
  final double minScale;
  final double maxScale;
  final EdgeInsets viewPadding;
  final EdgeInsets controlsPadding;

  @override
  State<SpaceMapViewport> createState() => _SpaceMapViewportState();
}

class _SpaceMapViewportState extends State<SpaceMapViewport> {
  final _controller = TransformationController();
  Size? _lastViewport;
  EdgeInsets? _lastViewPadding;
  double? _lastInitialScale;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Size(constraints.maxWidth, constraints.maxHeight);
        _setInitialTransform(viewport);

        return Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                transformationController: _controller,
                constrained: false,
                minScale: widget.minScale,
                maxScale: widget.maxScale,
                boundaryMargin: const EdgeInsets.all(360),
                onInteractionEnd: (_) => _stabilizeTransform(),
                child: RepaintBoundary(
                  child: SizedBox(
                    width: widget.mapSize.width,
                    height: widget.mapSize.height,
                    child: widget.child,
                  ),
                ),
              ),
            ),
            _PositionedControls(
              padding: widget.controlsPadding,
              child: SpaceMapControls(
                onZoomIn: () => _zoomBy(1.22),
                onZoomOut: () => _zoomBy(0.82),
                onReset: _resetTransform,
              ),
            ),
          ],
        );
      },
    );
  }

  void _setInitialTransform(Size viewport) {
    if (_lastViewport == viewport &&
        _lastViewPadding == widget.viewPadding &&
        _lastInitialScale == widget.initialScale) {
      return;
    }
    _lastViewport = viewport;
    _lastViewPadding = widget.viewPadding;
    _lastInitialScale = widget.initialScale;
    _controller.value = _initialTransformFor(viewport);
  }

  void _resetTransform() {
    final viewport = _lastViewport;
    if (viewport == null) return;
    _controller.value = _initialTransformFor(viewport);
  }

  void _zoomBy(double factor) {
    final viewport = _lastViewport;
    if (viewport == null) return;

    final currentScale = _controller.value.getMaxScaleOnAxis();
    if (currentScale == 0) return;

    final nextScale = math.min(
      math.max(currentScale * factor, widget.minScale),
      widget.maxScale,
    );

    if (nextScale <= widget.minScale * 1.01) {
      _controller.value = _centeredTransformFor(viewport, widget.minScale);
      return;
    }

    final ratio = nextScale / currentScale;
    final focalPoint = _visibleCenter(viewport);
    final next = Matrix4.identity()
      ..translateByDouble(focalPoint.dx, focalPoint.dy, 0, 1)
      ..scaleByDouble(ratio, ratio, 1, 1)
      ..translateByDouble(-focalPoint.dx, -focalPoint.dy, 0, 1);

    next.multiply(_controller.value);
    _controller.value = next;
    _stabilizeTransform();
  }

  void _stabilizeTransform() {
    final viewport = _lastViewport;
    if (viewport == null) return;

    final currentScale = _controller.value.getMaxScaleOnAxis();
    if (currentScale <= widget.minScale * 1.04) {
      _controller.value = _centeredTransformFor(
        viewport,
        currentScale.clamp(widget.minScale, widget.maxScale).toDouble(),
      );
    }
  }

  Offset _visibleCenter(Size viewport) {
    final visibleWidth = math.max(
      1,
      viewport.width - widget.viewPadding.horizontal,
    );
    final visibleHeight = math.max(
      1,
      viewport.height - widget.viewPadding.vertical,
    );
    return Offset(
      widget.viewPadding.left + visibleWidth / 2,
      widget.viewPadding.top + visibleHeight / 2,
    );
  }

  Matrix4 _initialTransformFor(Size viewport) {
    final visibleWidth = viewport.width - widget.viewPadding.horizontal;
    final visibleHeight = viewport.height - widget.viewPadding.vertical;
    final visibleSize = Size(
      math.max(1, visibleWidth),
      math.max(1, visibleHeight),
    );
    final fittedScale = math.min(
      visibleSize.width / widget.mapSize.width,
      visibleSize.height / widget.mapSize.height,
    );
    final preferredScale = widget.initialScale == null
        ? fittedScale
        : math.max(fittedScale, widget.initialScale!);
    final scale = math.min(
      math.max(preferredScale, widget.minScale),
      widget.maxScale,
    );
    return _centeredTransformFor(viewport, scale);
  }

  Matrix4 _centeredTransformFor(Size viewport, double scale) {
    final visibleWidth = viewport.width - widget.viewPadding.horizontal;
    final visibleHeight = viewport.height - widget.viewPadding.vertical;
    final visibleSize = Size(
      math.max(1, visibleWidth),
      math.max(1, visibleHeight),
    );
    final dx =
        widget.viewPadding.left +
        (visibleSize.width - widget.mapSize.width * scale) / 2;
    final dy =
        widget.viewPadding.top +
        (visibleSize.height - widget.mapSize.height * scale) / 2;

    return Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1);
  }
}

class _PositionedControls extends StatelessWidget {
  const _PositionedControls({required this.padding, required this.child});

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final useBottom = padding.bottom > 0;
    final useLeft = padding.left > 0;

    return Positioned(
      top: useBottom ? null : padding.top,
      right: useLeft ? null : padding.right,
      bottom: useBottom ? padding.bottom : null,
      left: useLeft ? padding.left : null,
      child: child,
    );
  }
}
