import 'package:flutter/material.dart';

class IRLightEffect extends StatelessWidget {
  const IRLightEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          size: Size(40, 15),
          painter: HalfCirclePainter(color: Color(0xFFD06ACB), sigma: 3.5),
        ),
        CustomPaint(
          size: Size(25, 10),
          painter: HalfCirclePainter(color: Color(0xFFECD8EC), sigma: 1.5),
        ),
      ],
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  final Color color;
  final double sigma;

  HalfCirclePainter({
    required this.color,
    required this.sigma,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height * 2),
      -3.14,
      3.14,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
