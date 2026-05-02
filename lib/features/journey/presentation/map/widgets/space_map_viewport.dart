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
    this.mapEdgeFade = 72,
    this.viewportEdgeFade = 36,
    this.viewPadding = EdgeInsets.zero,
    this.controlsPadding = const EdgeInsets.only(top: 12, right: 12),
  });

  final Size mapSize;
  final Widget child;
  final double? initialScale;
  final double minScale;
  final double maxScale;
  final double mapEdgeFade;
  final double viewportEdgeFade;
  final EdgeInsets viewPadding;
  final EdgeInsets controlsPadding;

  @override
  State<SpaceMapViewport> createState() => _SpaceMapViewportState();
}

class _SpaceMapViewportState extends State<SpaceMapViewport> {
  Size? _lastViewport;
  EdgeInsets? _lastViewPadding;
  double? _lastInitialScale;
  double? _lastMapEdgeFade;
  double _scale = 1;
  Offset _offset = Offset.zero;
  double _gestureStartScale = 1;
  Offset _gestureStartOffset = Offset.zero;
  Offset _gestureStartFocalPoint = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Size(constraints.maxWidth, constraints.maxHeight);
        final mapBleed = _mapBleed;
        final interactiveMapSize = _interactiveMapSize;
        _setInitialTransform(viewport);

        return Stack(
          children: [
            Positioned.fill(
              child: _SpaceMapEdgeFade(
                fade: widget.viewportEdgeFade,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                  onScaleEnd: (_) => _settleTransform(),
                  child: ClipRect(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: _offset.dx,
                          top: _offset.dy,
                          width: interactiveMapSize.width * _scale,
                          height: interactiveMapSize.height * _scale,
                          child: RepaintBoundary(
                            child: FittedBox(
                              fit: BoxFit.fill,
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: interactiveMapSize.width,
                                height: interactiveMapSize.height,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: mapBleed,
                                      top: mapBleed,
                                      width: widget.mapSize.width,
                                      height: widget.mapSize.height,
                                      child: widget.child,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  double get _mapBleed => math.max(0, widget.mapEdgeFade);

  Size get _interactiveMapSize {
    final bleed = _mapBleed * 2;
    return Size(widget.mapSize.width + bleed, widget.mapSize.height + bleed);
  }

  void _setInitialTransform(Size viewport) {
    if (_sameViewport(_lastViewport, viewport) &&
        _lastViewPadding == widget.viewPadding &&
        _lastInitialScale == widget.initialScale &&
        _lastMapEdgeFade == widget.mapEdgeFade) {
      return;
    }
    _lastViewport = viewport;
    _lastViewPadding = widget.viewPadding;
    _lastInitialScale = widget.initialScale;
    _lastMapEdgeFade = widget.mapEdgeFade;

    final transform = _initialTransformFor(viewport);
    _scale = transform.scale;
    _offset = transform.offset;
  }

  bool _sameViewport(Size? previous, Size next) {
    if (previous == null) return false;
    return (previous.width - next.width).abs() < 0.5 &&
        (previous.height - next.height).abs() < 0.5;
  }

  void _resetTransform() {
    final viewport = _lastViewport;
    if (viewport == null) return;
    final transform = _initialTransformFor(viewport);
    setState(() {
      _scale = transform.scale;
      _offset = transform.offset;
    });
  }

  void _zoomBy(double factor) {
    final viewport = _lastViewport;
    if (viewport == null) return;

    final nextScale = (_scale * factor).clamp(widget.minScale, widget.maxScale);
    final nextOffset = _scaledOffsetAround(
      focalPoint: _visibleCenter(viewport),
      currentOffset: _offset,
      currentScale: _scale,
      nextScale: nextScale,
    );

    setState(() {
      _scale = nextScale;
      _offset = _settledOffsetFor(
        viewport: viewport,
        scale: nextScale,
        currentOffset: nextOffset,
      );
    });
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _gestureStartScale = _scale;
    _gestureStartOffset = _offset;
    _gestureStartFocalPoint = details.localFocalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    final viewport = _lastViewport;
    if (viewport == null) return;

    final nextScale = (_gestureStartScale * details.scale).clamp(
      widget.minScale,
      widget.maxScale,
    );
    final scaleOffset = _scaledOffsetAround(
      focalPoint: _visibleCenter(viewport),
      currentOffset: _gestureStartOffset,
      currentScale: _gestureStartScale,
      nextScale: nextScale,
    );
    final panDelta = details.localFocalPoint - _gestureStartFocalPoint;

    setState(() {
      _scale = nextScale;
      _offset = _settledOffsetFor(
        viewport: viewport,
        scale: nextScale,
        currentOffset: scaleOffset + panDelta,
      );
    });
  }

  void _settleTransform() {
    final viewport = _lastViewport;
    if (viewport == null) return;

    final settledOffset = _settledOffsetFor(
      viewport: viewport,
      scale: _scale,
      currentOffset: _offset,
    );
    if ((settledOffset - _offset).distance < 0.5) return;

    setState(() {
      _offset = settledOffset;
    });
  }

  Offset _scaledOffsetAround({
    required Offset focalPoint,
    required Offset currentOffset,
    required double currentScale,
    required double nextScale,
  }) {
    if (currentScale <= 0) return currentOffset;

    final focalPointInMap = (focalPoint - currentOffset) / currentScale;
    return focalPoint - focalPointInMap * nextScale;
  }

  Offset _settledOffsetFor({
    required Size viewport,
    required double scale,
    required Offset currentOffset,
  }) {
    final visibleLeft = widget.viewPadding.left;
    final visibleTop = widget.viewPadding.top;
    final visibleWidth = math.max(
      1.0,
      viewport.width - widget.viewPadding.horizontal,
    );
    final visibleHeight = math.max(
      1.0,
      viewport.height - widget.viewPadding.vertical,
    );
    final mapSize = _interactiveMapSize;
    final scaledWidth = mapSize.width * scale;
    final scaledHeight = mapSize.height * scale;

    return Offset(
      _settledAxisOffset(
        currentOffset: currentOffset.dx,
        visibleStart: visibleLeft,
        visibleExtent: visibleWidth,
        scaledExtent: scaledWidth,
      ),
      _settledAxisOffset(
        currentOffset: currentOffset.dy,
        visibleStart: visibleTop,
        visibleExtent: visibleHeight,
        scaledExtent: scaledHeight,
      ),
    );
  }

  double _settledAxisOffset({
    required double currentOffset,
    required double visibleStart,
    required double visibleExtent,
    required double scaledExtent,
  }) {
    final settleSlack = math.max(96.0, _mapBleed);
    if (scaledExtent <= visibleExtent + settleSlack * 2) {
      return visibleStart + (visibleExtent - scaledExtent) / 2;
    }

    final minOffset = visibleStart + visibleExtent - scaledExtent - settleSlack;
    final maxOffset = visibleStart + settleSlack;
    return currentOffset.clamp(minOffset, maxOffset).toDouble();
  }

  Offset _visibleCenter(Size viewport) {
    final visibleWidth = math.max(
      1.0,
      viewport.width - widget.viewPadding.horizontal,
    );
    final visibleHeight = math.max(
      1.0,
      viewport.height - widget.viewPadding.vertical,
    );
    return Offset(
      widget.viewPadding.left + visibleWidth / 2,
      widget.viewPadding.top + visibleHeight / 2,
    );
  }

  _MapTransform _initialTransformFor(Size viewport) {
    final visibleWidth = viewport.width - widget.viewPadding.horizontal;
    final visibleHeight = viewport.height - widget.viewPadding.vertical;
    final visibleSize = Size(
      math.max(1.0, visibleWidth),
      math.max(1.0, visibleHeight),
    );
    final mapSize = _interactiveMapSize;
    final fittedScale = math.min(
      visibleSize.width / mapSize.width,
      visibleSize.height / mapSize.height,
    );
    final preferredScale = widget.initialScale == null
        ? fittedScale
        : math.max(fittedScale, widget.initialScale!);
    final scale = math.min(
      math.max(preferredScale, widget.minScale),
      widget.maxScale,
    );
    return _MapTransform(
      scale: scale,
      offset: _centeredOffsetFor(viewport, scale),
    );
  }

  Offset _centeredOffsetFor(Size viewport, double scale) {
    final visibleWidth = viewport.width - widget.viewPadding.horizontal;
    final visibleHeight = viewport.height - widget.viewPadding.vertical;
    final visibleSize = Size(
      math.max(1.0, visibleWidth),
      math.max(1.0, visibleHeight),
    );
    final mapSize = _interactiveMapSize;
    final dx =
        widget.viewPadding.left +
        (visibleSize.width - mapSize.width * scale) / 2;
    final dy =
        widget.viewPadding.top +
        (visibleSize.height - mapSize.height * scale) / 2;

    return Offset(dx, dy);
  }
}

class _MapTransform {
  const _MapTransform({required this.scale, required this.offset});

  final double scale;
  final Offset offset;
}

class _SpaceMapEdgeFade extends StatelessWidget {
  const _SpaceMapEdgeFade({required this.fade, required this.child});

  final double fade;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (fade <= 0) return child;

    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: _shader,
      child: child,
    );
  }

  Shader _shader(Rect bounds) {
    final edge = bounds.height <= 0
        ? 0.0
        : math.min(0.32, fade / bounds.height);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [
        Colors.transparent,
        Colors.white,
        Colors.white,
        Colors.transparent,
      ],
      stops: [0, edge, 1 - edge, 1],
    ).createShader(bounds);
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
