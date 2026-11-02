import 'package:flutter/material.dart';

enum NI { home, learn, free, duel, profile, eye, eyeOff }

class NIcon extends StatelessWidget {
  final NI type;
  final double size;
  final Color color;
  const NIcon(this.type, {super.key, this.size = 24, required this.color});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _P(type, color));
}

class _P extends CustomPainter {
  final NI t;
  final Color c;
  _P(this.t, this.c);

  @override
  void paint(Canvas cv, Size s) {
    final w = s.width;
    final p = Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.085
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    void m(double x, double y) => path.moveTo(x * w, y * w);
    void l(double x, double y) => path.lineTo(x * w, y * w);
    void q(double a, double b, double x, double y) =>
        path.quadraticBezierTo(a * w, b * w, x * w, y * w);
    switch (t) {
      case NI.home:
        m(.14, .50); l(.5, .16); l(.86, .50);
        m(.26, .44); l(.26, .84); l(.74, .84); l(.74, .44);
        break;
      case NI.learn:
        m(.5, .26); q(.3, .16, .1, .24); l(.1, .78); q(.3, .70, .5, .80); l(.5, .26);
        m(.5, .26); q(.7, .16, .9, .24); l(.9, .78); q(.7, .70, .5, .80);
        break;
      case NI.free:
        for (final o in [const Offset(.14, .14), const Offset(.56, .14), const Offset(.14, .56), const Offset(.56, .56)]) {
          cv.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromLTWH(o.dx * w, o.dy * w, .30 * w, .30 * w),
                  Radius.circular(.08 * w)),
              p);
        }
        break;
      case NI.duel:
        m(.58, .10); l(.24, .56); l(.50, .56); l(.42, .90); l(.76, .42); l(.50, .42); path.close();
        break;
      case NI.profile:
        cv.drawCircle(Offset(.5 * w, .34 * w), .16 * w, p);
        m(.18, .86); q(.5, .42, .82, .86);
        break;
      case NI.eye:
      case NI.eyeOff:
        m(.07, .5); q(.5, .12, .93, .5); q(.5, .88, .07, .5);
        cv.drawCircle(Offset(.5 * w, .5 * w), .12 * w, p);
        if (t == NI.eyeOff) {
          m(.2, .86); l(.8, .14);
        }
        break;
    }
    cv.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_P o) => o.t != t || o.c != c;
}
