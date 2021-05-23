import 'package:flutter/material.dart';

class  AchievementBackground extends StatelessWidget {
  final Color color;

  AchievementBackground({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 100,
      width: width,
      child: CustomPaint(
        painter: AchievementPainter(color: color),
      ),
    );
  }
}

class AchievementPainter extends CustomPainter {
  Color color;
  AchievementPainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.stroke;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(size.width * 0.58, size.height);

    path.lineTo(size.width * 0.85, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
