import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reporting_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF43B02A),
        elevation: 0,
        title: const Text(
          'Auto Repair',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30,
            ),
          ),
          // Logout IconButton in the AppBar
          IconButton(
            onPressed: () {
              _showLogoutDialog();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const SizedBox(height: 25),
              // Title below AppBar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Inventory Staff Dashboard',
                  style: GoogleFonts.dmSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                    color: Color(0xFF2E7D32),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Manage your inventory efficiently',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Function Cards
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // Real Time Stock Inquiry
                      _buildFunctionCard(
                        imageAsset: 'assets/images/realtime.png', // Image for Real Time Stock Inquiry
                        title: 'Real Time Stock Inquiry',
                        subtitle: 'Check current stock levels and availability',
                        onTap: () => _navigateToFunction('Stock Inquiry'),
                        delay: 200,
                      ),

                      const SizedBox(height: 20),

                      // Part Request/Issues
                      _buildFunctionCard(
                        imageAsset: 'assets/images/part.png', // Image for Part Request/Issues
                        title: 'Part Request/Issues',
                        subtitle: 'Manage part requests and report issues',
                        onTap: () => _navigateToFunction('Part Request'),
                        delay: 400,
                      ),

                      const SizedBox(height: 20),

                      // Inventory Adjustment
                      _buildFunctionCard(
                        imageAsset: 'assets/images/adjustment.png', // Image for Inventory Adjustment
                        title: 'Inventory Adjustment',
                        subtitle: 'Adjust inventory levels and quantities',
                        onTap: () => _navigateToFunction('Inventory Adjustment'),
                        delay: 600,
                      ),

                      const SizedBox(height: 20),

                      // Reporting Module
                      _buildFunctionCard(
                        imageAsset: 'assets/images/reporting.png', // Image for Reporting
                        title: 'Reports & Analytics',
                        subtitle: 'View inventory reports and analytics',
                        onTap: () => _navigateToReporting(),
                        delay: 800,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionCard({
    required String imageAsset,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required int delay,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFA5D6A7), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Image Container
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF43B02A),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _navigateToFunction(String functionName) {
    // Add fade-in transition for new page
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF43B02A),
              ),
              const SizedBox(height: 16),
              Text(
                'Opening $functionName...',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate loading and then close dialog
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$functionName feature coming soon!'),
            backgroundColor: const Color(0xFF43B02A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  void _navigateToReporting() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ReportingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // Clear login status
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    // Navigate back to sign in
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red logout button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
