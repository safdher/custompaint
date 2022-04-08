import 'dart:ui' as ui;
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  double percentage = 0.0;
  double newPercentage = 0.0;
  AnimationController? percentageAnimationController;
  AnimationController? eyeAnimationController;
  AnimationController? foodAnimationController;
  AnimationController? runAnimationController;
  Animation<double>? _animation;
  Animation<double>? _animationeye;
  Animation<double>? _animationFood;
  Animation<double>? _animationRun;
  Tween<double>? _tween;
  Tween<double>? _tween2;
  Tween<double>? _tween3;
  Tween<double>? _tween4;
  double chX = 0;
  double chY = 0;
  double posX = 26;
  double posY = 26;
  double fPosX = 130;
  double fPosY = 40;
  double score = 0;
  double direction = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      percentage = 0.0;
    });

    percentageAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    eyeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    foodAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    runAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    _tween = Tween(begin: 0.0, end: 90.0);

    _tween2 = Tween(begin: 2.0, end: 0.0);

    _tween3 = Tween(begin: 0.0, end: 5.0);

    _tween4 = Tween(begin: 10.0, end: 5.0);

    _animation = _tween!.animate(CurvedAnimation(
        parent: percentageAnimationController!, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {});
      });

    _animationeye = _tween2!.animate(
        CurvedAnimation(parent: eyeAnimationController!, curve: Curves.easeOut))
      ..addListener(() {
        if (_animationeye!.status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 5)).then((value) {
            eyeAnimationController!.forward(from: 0.2);
          });
          eyeAnimationController!.reset();
        }
        setState(() {});
      });

    _animationFood = _tween4!.animate(CurvedAnimation(
        parent: foodAnimationController!, curve: Curves.easeOut))
      ..addListener(() {
        // if (_animationFood!.status == AnimationStatus.completed) {
        //   Future.delayed(const Duration(seconds: 2)).then((value) {
        //     foodAnimationController!.forward(from: 0.2);
        //   });
        //   foodAnimationController!.reset();
        // }
        setState(() {});
      });

    _animationRun = _tween3!.animate(
        CurvedAnimation(parent: runAnimationController!, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          posX += score != 0
              ? (chX * score * _animationRun!.value)
              : (chX * _animationRun!.value);
          posY += score != 0
              ? (chY * score * _animationRun!.value)
              : (chY * _animationRun!.value);

          if (posX >= MediaQuery.of(context).size.width + 26) {
            posX = -26;
          } else if (posX <= -26) {
            posX = MediaQuery.of(context).size.width + 26;
          }

          if (posY >= MediaQuery.of(context).size.height + 26) {
            posY = -26;
          } else if (posY <= -26) {
            posY = MediaQuery.of(context).size.height + 26;
          }

          if (fPosX >= posX - 25 &&
              fPosX <= posX + 25 &&
              fPosY >= posY - 25 &&
              fPosY <= posY + 25) {
            fPosX = Random()
                .nextInt(MediaQuery.of(context).size.width.toInt())
                .toDouble();
            fPosY = Random()
                .nextInt(MediaQuery.of(context).size.height.toInt())
                .toDouble();
            score += 1;
          }
        });
      });
    percentageAnimationController!.repeat(reverse: true);
    eyeAnimationController!.forward();
    runAnimationController!.repeat();
    foodAnimationController!.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomPaint(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
          ),
          foregroundPainter: DemoPainter(
              _animation!.value,
              _animationeye!.value,
              posX,
              posY,
              direction,
              fPosX,
              fPosY,
              _animationFood!.value),
          painter: ForegroundPainter(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 165,
              height: 165,
              margin: const EdgeInsets.only(left: 50),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: const ui.Color.fromARGB(82, 221, 178, 50),
                  border: Border.all(
                    color: const ui.Color.fromARGB(132, 255, 255, 255),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(80))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          direction = 3 / 2;
                          chY = -1;
                          chX = 0;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: const ui.Color.fromARGB(132, 255, 255, 255),
                            border: Border.all(
                              color:
                                  const ui.Color.fromARGB(132, 255, 255, 255),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25))),
                        child: const Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white,
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              direction = 1;
                              chY = 0;
                              chX = -1;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color:
                                    const ui.Color.fromARGB(132, 255, 255, 255),
                                border: Border.all(
                                  color: const ui.Color.fromARGB(
                                      132, 255, 255, 255),
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(25))),
                            child: const Icon(
                              Icons.arrow_left,
                              color: Colors.white,
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            setState(() {
                              direction = 0;
                              chY = 0;
                              chX = 1;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color:
                                    const ui.Color.fromARGB(132, 255, 255, 255),
                                border: Border.all(
                                  color: const ui.Color.fromARGB(
                                      132, 255, 255, 255),
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(25))),
                            child: const Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                            ),
                          ))
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          direction = 1 / 2;
                          chY = 1;
                          chX = 0;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: const ui.Color.fromARGB(132, 255, 255, 255),
                            border: Border.all(
                              color:
                                  const ui.Color.fromARGB(132, 255, 255, 255),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25))),
                        child: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),
            Text(
              "Score : ${score.toInt()}",
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            Container(
              width: 165,
              height: 165,
              margin: const EdgeInsets.only(right: 50),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: const ui.Color.fromARGB(82, 221, 178, 50),
                  border: Border.all(
                    color: const ui.Color.fromARGB(132, 255, 255, 255),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(80))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          direction = 3 / 2;
                          chY = -1;
                          chX = 0;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: const ui.Color.fromARGB(132, 255, 255, 255),
                            border: Border.all(
                              color:
                                  const ui.Color.fromARGB(132, 255, 255, 255),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25))),
                        child: const Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white,
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              direction = 1;
                              chY = 0;
                              chX = -1;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color:
                                    const ui.Color.fromARGB(132, 255, 255, 255),
                                border: Border.all(
                                  color: const ui.Color.fromARGB(
                                      132, 255, 255, 255),
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(25))),
                            child: const Icon(
                              Icons.arrow_left,
                              color: Colors.white,
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            setState(() {
                              direction = 0;
                              chY = 0;
                              chX = 1;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color:
                                    const ui.Color.fromARGB(132, 255, 255, 255),
                                border: Border.all(
                                  color: const ui.Color.fromARGB(
                                      132, 255, 255, 255),
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(25))),
                            child: const Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                            ),
                          ))
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          direction = 1 / 2;
                          chY = 1;
                          chX = 0;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: const ui.Color.fromARGB(132, 255, 255, 255),
                            border: Border.all(
                              color:
                                  const ui.Color.fromARGB(132, 255, 255, 255),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25))),
                        child: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}

class ForegroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.black;
    canvas.drawPaint(paint);
    //canvas.drawCircle(Offset(center.width, center.height), 50.0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DemoPainter extends CustomPainter {
  double? percentage;
  double? eye;
  double? posX;
  double? posY;
  double? direction = 0;
  double? fPosX;
  double? fPosY;
  double? food;

  DemoPainter(this.percentage, this.eye, this.posX, this.posY, this.direction,
      this.fPosX, this.fPosY, this.food);

  @override
  void paint(Canvas canvas, Size size) {
    //var center = size / 2;
    var paint = Paint()..color = Colors.yellow;
    var paint2 = Paint()..color = const ui.Color.fromARGB(255, 0, 0, 0);
    var paint3 = Paint()..color = ui.Color.fromARGB(255, 245, 4, 4);
    var eyeX = posX! + 3;
    var eyeY = posY! - 10;
    if (direction == 1 / 2) {
      eyeX = posX! + 10;
      eyeY = posY! + 3;
    } else if (direction == 1) {
      eyeX = posX! - 3;
      eyeY = posY! - 10;
    } else if (direction == 3 / 2) {
      eyeX = posX! - 10;
      eyeY = posY! - 3;
    }
    canvas.drawCircle(Offset(fPosX!, fPosY!), food!, paint3);
    canvas.drawArc(
        Rect.fromCenter(
          center: Offset(posX!, posY!),
          width: 50,
          height: 50,
        ),
        (direction! * pi) + (0.8 * percentage! / 100),
        2 * pi - (1.6 * percentage! / 100),
        true,
        paint);

    canvas.drawCircle(Offset(eyeX, eyeY), eye!, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
