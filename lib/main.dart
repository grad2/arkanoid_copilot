import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arkanoid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

// напиши экран с мячем и планкой
// мяч должен быть круглым
// планка должна быть прямоугольной
// планка должна двигатся по горизонтали

//создай класс жизней

class Lives {
  int lives;
  Lives({required this.lives});
}


//создаем класс мяча

class Ball {
  double x;
  double y;
  double radius;
  double dx;
  double dy;
  Color color;
  Ball({
    required this.x,
    required this.y,
    required this.radius,
    required this.dx,
    required this.dy,
    required this.color,
  });
}

//создаем класс планки

class Paddle {
  double x;
  double y;
  double width;
  double height;
  Color color;
  Paddle({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.color,
  });
}

//создай класс счета

class Score {
  int score;
  Score({required this.score});
}

//создадим класс для отрисовки мяча

class BallPainter extends CustomPainter {
  final Ball ball;
  BallPainter(this.ball);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ball.color;
    canvas.drawCircle(Offset(ball.x, ball.y), ball.radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//создай класс для отрисовки жизней

class LivesPainter extends CustomPainter {
  final Lives lives;
  LivesPainter(this.lives);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.red;
    //отрисовка жизней
    for (int i = 0; i < lives.lives; i++) {
      canvas.drawCircle(Offset(20 + i * 20, 20), 10, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//создадим класс для отрисовки планки

class PaddlePainter extends CustomPainter {
  final Paddle paddle;
  PaddlePainter(this.paddle);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = paddle.color;
    canvas.drawRect(
        Rect.fromLTWH(paddle.x, paddle.y, paddle.width, paddle.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//создай класс для того чтобы шарик двигался

class BallMover extends CustomPainter {
  final Ball ball;
  BallMover(this.ball);
  @override
  void paint(Canvas canvas, Size size) {
    ball.x += ball.dx;
    ball.y += ball.dy;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//создай класс для того чтобы планка двигалась с помощью жестов и не могла выйти за границы экрана

class PaddleMover extends CustomPainter {
  final Paddle paddle;
  PaddleMover(this.paddle);
  @override
  void paint(Canvas canvas, Size size) {
    if (paddle.x + paddle.width >= size.width) {
      paddle.x = size.width - paddle.width;
    }
    if (paddle.x <= 0) {
      paddle.x = 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//создай класс для того чтобы шарик отскакивал от границ экрана

class BallBouncer extends CustomPainter {
  final Ball ball;
  BallBouncer(this.ball);
  @override
  void paint(Canvas canvas, Size size) {
    if (ball.x + ball.radius >= size.width) {
      ball.dx = -ball.dx;
    }
    if (ball.x - ball.radius <= 0) {
      ball.dx = -ball.dx;
    }
    if (ball.y + ball.radius >= size.height) {
      ball.dy = -ball.dy;
    }
    if (ball.y - ball.radius <= 0) {
      ball.dy = -ball.dy;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//создай класс для того чтобы шарик отскакивал от границ планки

//создадим класс для отрисовки счета

class ScorePainter extends CustomPainter {
  final Score score;
  ScorePainter(this.score);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    //измени цвет счета на черный
    final textStyle = TextStyle(color: Colors.black, fontSize: 30);
    final textSpan = TextSpan(text: score.score.toString(), style: textStyle);
    final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - 10, 20));

    //отрисуй счет по центру экрана
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BallPaddleBouncer extends CustomPainter {
  final Ball ball;
  final Paddle paddle;
  BallPaddleBouncer(this.ball, this.paddle);
  @override
  void paint(Canvas canvas, Size size) {
    if (ball.x + ball.radius >= paddle.x &&
        ball.x - ball.radius <= paddle.x + paddle.width &&
        ball.y + ball.radius >= paddle.y &&
        ball.y - ball.radius <= paddle.y + paddle.height) {
      ball.dy = -ball.dy;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//создай класс для того чтоб шарик переносился в центр экрана если шарик коснется нижней границы экрана и уменьшалось количество жизней

class BallLives extends CustomPainter {
  final Ball ball;
  final Lives lives;
  BallLives(this.ball, this.lives);
  @override
  void paint(Canvas canvas, Size size) {
    if (ball.y + ball.radius >= size.height) {
      //мяч должен перемещатся в центр экрана
      ball.x = size.width / 2;
      ball.y = size.height / 2;
      //мяч должен менят направление движение  случайно
      ball.dx = Random().nextBool() ? 5 : -5;
      lives.lives -= 1;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//создай класс экрана на который мы будем переходить когда у нас закончатся жизни
// на экрана должен быть текст того что мы проиграли
// кнопка для того чтобы начать игру заново

class GameOverScreen extends StatelessWidget {
  final int score;
  GameOverScreen({required this.score});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 30),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => GameScreen()));
                },
                child: Text('Restart'))
          ],
        ),
      ),
    );
  }
}

//создадим класс игрового экрана и добавим в него все наши классы
// добавь счетчик отчков

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  late Ball ball;
  late Paddle paddle;
  late Lives lives;
  //добавь счет
  late Score score;
  @override
  void initState() {
    super.initState();
    ball = Ball(
      x: 100,
      y: 100,
      radius: 10,
      dx: 5,
      dy: 5,
      color: Colors.red,
    );
    //создай счет

    score = Score(score: 0);

    //планка должа находится в нижней часте экрана по y и в центре по x
    paddle = Paddle(
      x: 100,
      y: 500,
      width: 100,
      height: 20,
      color: Colors.blue,
    );
    lives = Lives(lives: 3);
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      //добавляй счет
      score.score += 1;

      //проверяем если у нас закончились жизни то переходим на экран GameOverScreen
      if (lives.lives == 0) {
        timer.cancel();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => GameOverScreen(score: score.score)));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            paddle.x += details.delta.dx;
          });
        },
        //создадим вложеность виджетов для отрисовки нашего экрана
        child: CustomPaint(
          painter: PaddlePainter(paddle),
          child: CustomPaint(
            painter: BallMover(ball),
            child: CustomPaint(
              painter: PaddleMover(paddle),
              child: CustomPaint(
                painter: BallBouncer(ball),
                child: CustomPaint(
                  painter: BallPaddleBouncer(ball, paddle),
                  child: CustomPaint(
                    painter: BallLives(ball, lives),
                    child: CustomPaint(
                      painter: BallPainter(ball),
                      child: CustomPaint(
                        painter: LivesPainter(lives),
                        //добавь счетчик отчков
                        child: CustomPaint(
                          painter: ScorePainter(score),
                            child: Container(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



