import 'dart:ui' as UI;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rollingball/constant/my_constant.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class GuestScreen extends StatefulWidget {
  @override
  _PlanetsState createState() => _PlanetsState();
}

bool _isMatch = false;
bool isStop = true;

class _PlanetsState extends State<GuestScreen> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _animation;
  String result = "Result";

  dynamic _value = 1.0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds:3),
    );
    _animation = Tween(begin: 0.0, end: _value).animate(_controller!)
      ..addListener(() {});
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 50),
                  width: width * 0.2,
                  height: height * 0.08,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: _isMatch ? Colors.green : Colors.red),
                  child: Center(child: Text(result))),
              Container(
                  margin: EdgeInsets.only(top: 50),
                  width: width * 0.3,
                  height: height * 0.08,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      color: Colors.blue.withOpacity(0.3)),
                  child: Center(child: Text('Guest Mode')),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.21,
          ),
          AnimatedBuilder(
              animation: _controller!,
              builder: (context, snapshot) {
                return Center(
                  child: CustomPaint(
                    painter: AtomPaint(
                      value: _controller!.value,
                      animation: _animation,
                    ),
                  ),
                );
              }),
          SizedBox(
            height: height * 0.25,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.withOpacity(0.2)),
            width: width * 0.9,
            child: SfSlider(
              min: 1.0,
              max: 1000.0,
              value: _value,
              interval: 999,
              showTicks: true,
              showLabels: true,
              enableTooltip: true,
              minorTicksPerInterval: 50,
              onChanged: (value) {
                setState(() {
                  _value = value;
                  int range = value.toInt();
                  print("speed is $range");
                  if(range==1000){
                    _controller!.duration = Duration(milliseconds: 10);
                  }
                 else{
                    int speed = 1000 - range;
                    _controller!.duration = Duration(milliseconds:speed*2);
                  }
                  _controller?.forward();
                  _controller?.repeat();
                });
              },
            ),
          ),
          SizedBox(
            height: height * 0.1,
          ),

          GestureDetector(
            child: Container(
              //width: width * 0.40,
              height: height * 0.15,
              child:  Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 5),
                child: Center(
                  child: isStop?const Text(
                    "Start",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ):const Text(
                    "Stop",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //borderRadius: BorderRadius.circular(10),
                  color: isStop?Colors.green:Colors.red),
            ),
            onTap: () {
              isStop?startAction():stopAction();
            },
          ),

        ],
      ),
    );
  }

  startAction(){
    _controller?.forward();
    _controller?.repeat();
    setState(() {
      isStop = false;
    });
  }
  stopAction(){
    _controller?.stop();
    bool check = AtomPaint.checkCordination();
    isStop = true;
    if (check == true) {
      setState(() {
        result = "Win!";
        _isMatch = true;
        offset = Offset(10, 155);
      });
    } else {
      setState(() {
        _isMatch = false;
        result = "Loss!";
      });
    }
  }

}

var offset;

class AtomPaint extends CustomPainter {
  AtomPaint({
    required this.value,
    required this.animation,
  });

  Animation? animation;
  static var offset1;
  final double value;
  var ovalPath;
  Paint _axisPaint = Paint()
    ..color = Colors.green
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    drawAxis(
        value,
        canvas,
        156,
        Paint()
          ..color = isStop
              ? _isMatch
              ? Colors.green
              : Colors.red
              : Colors.blue);
  }

  drawAxis(double value, Canvas canvas, double radius, Paint paint) {
    ovalPath = getCirclePath(radius);

    canvas.drawPath(
      ovalPath,
      _axisPaint,
    );
    cicle(ovalPath, canvas, paint, 1);
    cicle2(ovalPath, canvas);
  }

  Path getCirclePath(double radius) {
    return Path()
      ..addOval(Rect.fromCircle(center: Offset(0, 0), radius: radius));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void cicle(var ovalPath, Canvas canvas, Paint paint, double devision) {
    UI.PathMetrics pathMetrics = ovalPath.computeMetrics();
    for (UI.PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * value,
      );
      try {
        var metric = extractPath.computeMetrics().first;
        offset = metric.getTangentForOffset(metric.length)?.position;
        print("offset of circle one is ${offset}");
        canvas.drawCircle((calculate(animation?.value)!), 20.0, paint);
      } catch (e) {}
    }
  }

  void cicle2(var ovalPath, Canvas canvas) {
    UI.PathMetrics pathMetrics = ovalPath.computeMetrics();
    for (UI.PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * value,
      );
      try {
        offset1 = Offset(10, 155);
        canvas.drawCircle(offset1!, 20.0, Paint()..color = Colors.green);
        print("offset of circle 2 is ${offset1}");
      } catch (e) {}
    }
  }

  static bool checkCordination() {
    bool resultX = isXAxisNear();
    bool resultY = isYAxisNear();

    if (resultX && resultY) {
      return true;
    } else {
      return false;
    }
    // if((offset!.dx<=80 && offset!.dx >=50 ) && (offset!.dy <=150 &&offset!.dy >=130))
    // {
    //   return true;
    // }
    // else
    // {
    //   return false;
    // }
  }

  static bool isXAxisNear() {
    print("////current position is ${offset1.dx},${offset1.dy}");
    // giving margin of 7;
    if (offset1!.dx >= offset.dx - 1 && offset1.dx <= offset.dx + 1) {
      return true;
    } else {
      return false;
    }
  }

  static bool isYAxisNear() {
    // giving margin of 7;
    if (offset1!.dy >= offset.dy - 3 && offset1.dy <= offset.dy + 3) {
      return true;
    } else {
      return false;
    }
  }

  Offset? calculate(value) {
    PathMetrics? pathMetrics = ovalPath?.computeMetrics();
    PathMetric? pathMetric = pathMetrics?.elementAt(0);
    value = (pathMetric!.length * value);
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos?.position;
  }
}
