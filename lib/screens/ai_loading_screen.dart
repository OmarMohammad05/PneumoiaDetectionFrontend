import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:breathe_x/accounts/result_page.dart';

class AILoadingScreen extends StatefulWidget {
  static const id = 'AILoadingScreen';
  final String prediction;

  const AILoadingScreen({Key? key, required this.prediction}) : super(key: key);

  @override
  State<AILoadingScreen> createState() => _AILoadingScreenState();
}

class _AILoadingScreenState extends State<AILoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation glow effect
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);

    _simulateAIProcessing();
  }

  Future<void> _simulateAIProcessing() async {
    await Future.delayed(const Duration(seconds: 10)); // simulate loading time

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(prediction: widget.prediction),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFB8860B),
                      Colors.transparent,
                    ],
                    radius: 0.9,
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Analyzing Data with AI...",
              style: GoogleFonts.poppins(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Real-time diagnostics in progress",
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 50),

            // خط تحميل أنيق
            Container(
              width: 180,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFB8860B),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
