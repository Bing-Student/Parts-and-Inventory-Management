import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo at the top
                SlideTransition(
                  position: _slideAnimation,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 110,
                    height: 110,
                  ),
                ),

                const SizedBox(height: 10),

                // Main title - Urbanist
                SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'Welcome to Auto Repair',
                    style: GoogleFonts.urbanist(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E3A5F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle - Chakra Petch
                SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'Your Business with Advanced\nSpare Part Management Software.',
                    style: GoogleFonts.chakraPetch(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Spacer to push content up and image/button down
                const Spacer(flex: 1),

                // Main illustration image
                SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    height: 315,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/welcome.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Get Started Button - Default font (Roboto)
                SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: widget.onSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign In Link - Urbanist
                SlideTransition(
                  position: _slideAnimation,
                  child: GestureDetector(
                    onTap: widget.onGetStarted,
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account?",
                        style: GoogleFonts.urbanist(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up.',
                            style: GoogleFonts.urbanist(
                              color: const Color(0xFF2196F3),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}