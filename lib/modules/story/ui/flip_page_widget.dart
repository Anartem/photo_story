import 'package:flutter/material.dart';
import 'dart:math';

class FlipPageWidget extends StatefulWidget {
  final Widget Function(int) itemBuilder;
  final int itemCount;

  const FlipPageWidget.builder({
    required this.itemBuilder,
    required this.itemCount,
    Key? key
  }) : super(key: key);

  @override
  _FlipPageViewState createState() => _FlipPageViewState();
}

class _FlipPageViewState extends State<FlipPageWidget> {
  final FlipController _controller = FlipController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _FlipPage(
          controller: _controller,
          itemBuilder: (index) => index < 0 || index > widget.itemCount
            ? Container()
            : widget.itemBuilder(index),
        ),
        PageView.builder(
          controller: _controller,
          itemBuilder: (context, index) => Container(),
          itemCount: (widget.itemCount / 2).ceil(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FlipPosition {
  double position;
  int page;

  FlipPosition(this.position, this.page);
}

class _FlipPage extends AnimatedWidget {
  static const double maxTilt = 0.003;

  final Widget Function(int) itemBuilder;
  final FlipController controller;

  const _FlipPage({
    required this.controller,
    required this.itemBuilder,
    Key? key,
  }): super(key: key, listenable: controller);

  int get _page => controller.index;

  double get _position {
    double position = controller.hasClients ? (controller.page ?? 0) : controller.initialPage.toDouble();
    //print("position ${position - position.floor()} $_page");
    return position - position.floor();
  }

  bool get _isFront => _position < 0.5;

  double _rotationAngle() {
    final double rotationValue = _position * pi;

    return _isFront
      ? rotationValue
      : pi - rotationValue;
  }

  double _getTilt() {
    final double tilt = 0.5 - (_position - 0.5).abs();
    return tilt * (_isFront ? -maxTilt : maxTilt);
  }

  @override
  Widget build(BuildContext context) {
    int index = 2 * _page;

    final Matrix4 matrix = Matrix4
      .rotationY(_rotationAngle())
      ..setEntry(3, 0, _getTilt());

    return Stack(
      fit: StackFit.expand,
      children: [
        TwoPageWidget(
          left: Container(
            foregroundDecoration: BoxDecoration(
              gradient: _isFront
                ? null
                : LinearGradient(
                  colors: const [Colors.black, Colors.black, Colors.transparent, Colors.transparent],
                  stops: [0, -cos(pi * _position), min(1, -2 * cos(pi * _position)), 1],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                )
            ),
            child: itemBuilder(index),
          ),
          right: Container(
            foregroundDecoration: BoxDecoration(
              gradient: !_isFront
                ? null
                : LinearGradient(
                  colors: const [Colors.black, Colors.black, Colors.transparent, Colors.transparent],
                  stops: [0, cos(pi * _position), min(1, 2 * cos(pi * _position)), 1],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
            ),
            child: itemBuilder(index + 3),
          )
        ),
        Transform(
          transform: matrix,
          alignment: Alignment.center,
          child: _isFront
            ? TwoPageWidget(right: itemBuilder(index + 1))
            : TwoPageWidget(left: itemBuilder(index + 2)),
        )
      ],
    );
  }
}

class FlipController extends PageController {
  int index = 0;

  FlipController({int initialPage = 0}): super(initialPage: initialPage) {
    addListener(() {
      if (page?.ceil() == page?.floor()) {
        index = page?.ceil() ?? 0;
      }
    });
  }
}

class TwoPageWidget extends StatefulWidget {
  final Widget? left;
  final Widget? right;

  const TwoPageWidget({
    this.left,
    this.right,
    Key? key
  }) : super(key: key);

  @override
  _TwoPageWidgetState createState() => _TwoPageWidgetState();
}

class _TwoPageWidgetState extends State<TwoPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: widget.left ?? Container()),
        Expanded(child: widget.right ?? Container()),
      ],
    );
  }
}

/*class TwoPageWidget extends StatelessWidget {
  final Widget? left;
  final Widget? right;

  const TwoPageWidget({
    this.left,
    this.right,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left ?? Container()),
        Expanded(child: right ?? Container()),
      ],
    );
  }
}*/
