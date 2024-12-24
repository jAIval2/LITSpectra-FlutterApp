import 'package:flutter/material.dart';
import 'login_signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'ProtoMono', color: Color(0xFFF1F0E1)),
          bodySmall: TextStyle(fontFamily: 'ProtoMono', color: Color(0xFFF1F0E1)),
        ),
      ),
      home: IntroSlides(),
    );
  }
}

class IntroSlides extends StatefulWidget {
  @override
  _IntroSlidesState createState() => _IntroSlidesState();
}

class _IntroSlidesState extends State<IntroSlides> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              IntroSlide(
                title: "Welcome to LITSpectra",
                subtext: "Your guide to sustainable energy consumption.",
                background: Color(0xFF857250), // Color #857250
                textPosition: Alignment.bottomLeft,
                painter: SimpleGeometricPainter1(),
              ),
              IntroSlide(
                title: "Track Your Energy",
                subtext: "Monitor your usage and expenses in real-time.",
                background: Color(0xFF628550), // Color #628550
                textPosition: Alignment.bottomLeft,
                painter: SimpleGeometricPainter2(),
              ),
              IntroSlide(
                title: "Manage Your Bills",
                subtext: "Get insights on your billing and payment status.",
                background: Color(0xFF506385), // Color #506385
                textPosition: Alignment.bottomLeft,
                painter: SimpleGeometricPainter3(),
              ),
              IntroSlide(
                title: "Go Solar!",
                subtext: "Explore solar energy options for your home.",
                background: Color(0xFF855063), // Color #855063
                textPosition: Alignment.bottomLeft,
                painter: SimpleGeometricPainter4(),
              ),
              IntroSlide(
                title: "Join the Movement",
                subtext: "Make a difference with eco-friendly choices.",
                background: Color(0xFF00796B), // Darker teal
                textPosition: Alignment.bottomLeft,
                isLastSlide: true,
                onLastSlideTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginSignupScreen()),
                  );
                },
                painter: SimpleGeometricPainter5(),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - (_currentPage * 10),
            child: Row(
              children: List.generate(5, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.white : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroSlide extends StatelessWidget {
  final String title;
  final String subtext;
  final Color background;
  final Alignment textPosition;
  final bool isLastSlide;
  final VoidCallback? onLastSlideTap;
  final CustomPainter painter;

  const IntroSlide({
    Key? key,
    required this.title,
    required this.subtext,
    required this.background,
    required this.textPosition,
    this.isLastSlide = false,
    this.onLastSlideTap,
    required this.painter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: background,
          child: Center(
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: painter,
            ),
          ),
        ),
        Align(
          alignment: textPosition,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Align to the bottom
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'ProtoMono',
                    fontSize: 28,
                    color: Colors.black, // Change text color to black
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  subtext,
                  style: TextStyle(
                    fontFamily: 'ProtoMono',
                    fontSize: 18,
                    color: Colors.black, // Change text color to black
                  ),
                ),
                if (isLastSlide)
                  SizedBox(height: 40),
                if (isLastSlide)
                  PulsingButton(
                    onPressed: onLastSlideTap,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PulsingButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const PulsingButton({Key? key, this.onPressed}) : super(key: key);

  @override
  _PulsingButtonState createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<PulsingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation and set it to repeat
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF506385), // Button background color
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: TextStyle(
                fontFamily: 'ProtoMono',
                fontSize: 18,
                color: Colors.black, // Change button text color to white
              ),
            ),
            child: Text("Proceed to Dashboard"),
          ),
        );
      },
    );
  }
}

// Custom Painters for different geometric designs
class SimpleGeometricPainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw simple circles
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawCircle(Offset(i, size.height / 2), 20, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SimpleGeometricPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw simple rectangles
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawRect(Rect.fromLTWH(i, size.height / 2 - 10, 30, 20), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SimpleGeometricPainter3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw diagonal lines
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(size.width - i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SimpleGeometricPainter4 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw simple triangles
    for (double i = 0; i < size.width; i += 50) {
      Path path = Path();
      path.moveTo(i, size.height / 2);
      path.lineTo(i + 20, size.height / 2 - 30);
      path.lineTo(i + 40, size.height / 2);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SimpleGeometricPainter5 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw concentric circles
    for (double i = 20; i < size.width / 2; i += 20) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), i, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
