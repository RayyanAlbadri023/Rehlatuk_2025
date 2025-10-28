import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'ad1.dart';

class WallpaperPage extends StatefulWidget {
  const WallpaperPage({super.key});

  @override
  _WallpaperPageState createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _bottomTextController;

  @override
  void initState() {
    super.initState();

    // ===== حركة الشعار تدريجي مع زووم + رقص مستمر (3 ثوانٍ للنزول، ثم استمرار الرقص) =====
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    // ===== حركة الحروف تتجمع من الأطراف مع رقص طفيف =====
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // ===== حركة النص السفلي Fade-in =====
    _bottomTextController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // بدء حركة الحروف قبل انتهاء الشعار عند نسبة 70%
    _logoController.addListener(() {
      if (_logoController.value >= 0.7 && !_textController.isAnimating) {
        _textController.forward();
      }
    });

    // بدء تلاشي النص السفلي قبل انتهاء حركة الحروف عند 80%
    _textController.addListener(() {
      if (_textController.value >= 0.8 && !_bottomTextController.isAnimating) {
        _bottomTextController.forward();
      }
    });

    // الانتقال بعد 7 ثوانٍ تقريبًا لمزامنة الحركة
    Future.delayed(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Ad1Screen()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _bottomTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letters = "REHLATUK".split('');

    return Scaffold(
      backgroundColor: const Color(0xFF160948),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ===== الشعار يظهر من فوق مع زووم + رقص مستمر =====
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                final progress = _logoController.value.clamp(0.0, 1.0);

                // نزول تدريجي من الأعلى
                final offsetY = -150 * (1 - progress);

                // رقص مستمر ±7px (حتى بعد الوصول)
                final bounce = math.sin(DateTime.now().millisecondsSinceEpoch * 0.004) * 7;

                final scale = 0.5 + 0.5 * progress;
                final opacity = progress;

                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(0, offsetY + bounce),
                    child: Transform.scale(
                      scale: scale,
                      child: Image.asset(
                        'assets/logo.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // ===== حروف الكلمة تتجمع من الأطراف إلى المركز مع رقص طفيف =====
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(letters.length, (index) {
                    final progress = _textController.value.clamp(0.0, 1.0);

                    final direction = index < letters.length / 2 ? -1 : 1;
                    final startX = direction * 300;
                    final offsetX = startX * (1 - progress);

                    // رقص خفيف لكل حرف
                    final offsetY = math.sin(progress * math.pi * 2 + index) * 4;

                    return Transform.translate(
                      offset: Offset(offsetX, offsetY),
                      child: Text(
                        letters[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),

            const SizedBox(height: 35),

            // ===== النص السفلي يظهر بتلاشي تدريجي قبل نهاية حركة الحروف =====
            FadeTransition(
              opacity: _bottomTextController,
              child: const Text(
                "Let’s take off together...",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
