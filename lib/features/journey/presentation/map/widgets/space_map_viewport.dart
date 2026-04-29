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
  });

  final Size mapSize;
  final Widget child;
  final double? initialScale;
  final double minScale;
  final double maxScale;

  @override
  State<SpaceMapViewport> createState() => _SpaceMapViewportState();
}

class _SpaceMapViewportState extends State<SpaceMapViewport> {
  final _controller = TransformationController();
  Size? _lastViewport;

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
                child: RepaintBoundary(
                  child: SizedBox(
                    width: widget.mapSize.width,
                    height: widget.mapSize.height,
                    child: widget.child,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
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
    if (_lastViewport == viewport) return;
    _lastViewport = viewport;
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
    final ratio = nextScale / currentScale;
    final focalPoint = Offset(viewport.width / 2, viewport.height / 2);
    final next = Matrix4.identity()
      ..translateByDouble(focalPoint.dx, focalPoint.dy, 0, 1)
      ..scaleByDouble(ratio, ratio, 1, 1)
      ..translateByDouble(-focalPoint.dx, -focalPoint.dy, 0, 1);

    next.multiply(_controller.value);
    _controller.value = next;
  }

  Matrix4 _initialTransformFor(Size viewport) {
    final fittedScale = math.min(
      viewport.width / widget.mapSize.width,
      viewport.height / widget.mapSize.height,
    );
    final preferredScale = widget.initialScale == null
        ? fittedScale
        : math.max(fittedScale, widget.initialScale!);
    final scale = math.min(
      math.max(preferredScale, widget.minScale),
      widget.maxScale,
    );
    final dx = (viewport.width - widget.mapSize.width * scale) / 2;
    final dy = (viewport.height - widget.mapSize.height * scale) / 2;

    return Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1);
  }
}
