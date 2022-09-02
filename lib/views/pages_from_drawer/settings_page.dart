import 'package:flutter/material.dart';


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             SizedBox(
               height: 8.0,
               width: 5.0,
               child: CustomPaint(
                 painter: TrianglePainter(),
               ),
             ),
             Container(
               decoration: BoxDecoration(
                   color: Colors.red,
                   borderRadius: BorderRadius.only(
                       topRight: Radius.circular(6.0),
                       bottomLeft: Radius.circular(6.0))),
               width: 120.0,
               height: 30.0,
               child: Center(
                 child: Text(
                   'Customer Replay',
                  style: TextStyle(color: Colors.white),
                 ),
               ),
             ),
           ],
          ),
      ),
    );
  }
}
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;
    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}