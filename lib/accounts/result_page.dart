import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ResultPage extends StatelessWidget {
  static const id = 'ResultPage';
  final String prediction;

  const ResultPage({Key? key, required this.prediction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPneumonia =
        prediction.toLowerCase().contains("pneumonia") || prediction == '1';

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Diagnosis Result",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // إضاءة خلف الأيقونة
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      isPneumonia
                          ? Colors.redAccent.withOpacity(0.3)
                          : Colors.yellowAccent.withOpacity(0.25),
                      Colors.transparent
                    ],
                    radius: 0.8,
                  ),
                ),
                child: Icon(
                  isPneumonia
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline_rounded,
                  size: 90,
                  color: isPneumonia ? Colors.redAccent : const Color(0xFFFFD700),
                ),
              ),
              const SizedBox(height: 40),

              // النص الرئيسي
              Text(
                isPneumonia
                    ? "Pneumonia Detected"
                    : "Healthy - No Pneumonia",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),

              const SizedBox(height: 14),
              Text(
                "AI-powered diagnosis completed",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 50),

              // الزر الذهبي
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFB8860B),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  label: Text(
                    "Back to Form",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
