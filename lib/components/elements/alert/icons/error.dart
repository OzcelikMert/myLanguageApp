import 'package:flutter/material.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class ErrorView extends StatefulWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ErrorViewState();
}

class ErrorViewState extends State<ErrorView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween(begin: 90.0, end: 0.0),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 300),
            tag: "rotation")
        .addAnimatable(
            animatable: Tween(begin: 0.3, end: 1.0),
            from: Duration(milliseconds: 600),
            to: Duration(milliseconds: 900),
            tag: "fade",
            curve: Curves.bounceOut)
        .addAnimatable(
            animatable: Tween(begin: 32.0 / 5.0, end: 32.0 / 2.0),
            from: Duration(milliseconds: 600),
            to: Duration(milliseconds: 900),
            tag: "fact",
            curve: Curves.bounceOut)
        .animate(animationController);

    // delay
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      forward();
    });

    super.initState();
  }

  void forward() {
    animationController
        .animateTo(1.0,
            duration: Duration(milliseconds: 600), curve: Curves.ease)
        .then((_) {});
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (c, w) {
          return Transform(
            transform: Matrix4.rotationX(
                math.radians(sequenceAnimation['rotation'].value)),
            origin: Offset(0.0, 32.0),
            child: CustomPaint(
              painter: _CustomPainter(
                  color: ThemeConst.colors.danger,
                  fade: sequenceAnimation['fade'].value,
                  factor: sequenceAnimation['fact'].value),
            ),
          );
        });
  }
}

class _CustomPainter extends CustomPainter {
  Paint _paint = Paint();

  Color color;

  double _r = 32.0;
  final double fade;
  final double factor;

  _CustomPainter(
      {required this.color, required this.fade, required this.factor}) {
    _paint.strokeCap = StrokeCap.round;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 4.0;
    _paint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    _paint.color = color;

    path.addArc(Rect.fromCircle(center: Offset(_r, _r), radius: _r), 0.0,
        math.radians(360.0));
    canvas.drawPath(path, _paint);

    path = Path();

    _paint.color =
        Color(color.value & 0x00FFFFFF + ((0xff * fade).toInt() << 24));

    path.moveTo(_r - factor, _r - factor);
    path.lineTo(_r + factor, _r + factor);

    path.moveTo(_r + factor, _r - factor);
    path.lineTo(_r - factor, _r + factor);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(_CustomPainter oldDelegate) {
    return color != oldDelegate.color || fade != oldDelegate.fade;
  }
}
