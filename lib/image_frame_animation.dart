library image_frame_animation;

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'frame-controller.dart';

class ImageFrameAnimation extends StatefulWidget {
  final FrameController frameController;
  ImageFrameAnimation({Key? key, required this.frameController})
      : assert(frameController.images.isNotEmpty,
            "请在加载此组件前初始化FrameController，并等待load的调用"),
        super(key: key);

  @override
  _ImageFrameAnimationState createState() => _ImageFrameAnimationState();
}

class _ImageFrameAnimationState extends State<ImageFrameAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 20));

  late final Animation<int> _animation;

  late ValueNotifier<ui.Image> _valueNotifier =
      ValueNotifier(widget.frameController.images[0]);

  @override
  void initState() {
    super.initState();
    _animation =
        IntTween(begin: 0, end: widget.frameController.images.length - 1)
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.linear));

    _animationController.addListener(() {
      _valueNotifier.value = widget.frameController.images[_animation.value];
    });

    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomPaint(
          painter: _Painter(valueNotifier: _valueNotifier),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final ValueNotifier<ui.Image> valueNotifier;

  final _paint = Paint();

  _Painter({required this.valueNotifier}) : super(repaint: valueNotifier);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(valueNotifier.value, Offset.zero, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
