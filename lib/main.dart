import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your screen files
import 'pages/onboarding/intro_screen.dart';    // Page 1
import 'pages/onboarding/welcome_screen.dart'; // Page 2
import 'pages/onboarding/signup_screen.dart';   // Leads from Welcome or Sign In
import 'pages/onboarding/signin_screen.dart';  // Page 3 (or direct entry if intro seen)
import 'dashboard_screen.dart'; // Page after successful sign-in

// A key for SharedPreferences
const String seenIntroKey = 'seenIntro';
const String isLoggedInKey = 'isLoggedIn';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late Future<bool> _userHasSeenIntroFuture;
  late Future<bool> _isUserLoggedInFuture;

  @override
  void initState() {
    super.initState();
    _userHasSeenIntroFuture = _checkIfUserHasSeenIntro();
    _isUserLoggedInFuture = _checkIfUserIsLoggedIn();
  }

  Future<bool> _checkIfUserHasSeenIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(seenIntroKey) ?? false;
  }

  Future<bool> _checkIfUserIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  Future<void> _markIntroAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(seenIntroKey, true);
    setState(() {
      _userHasSeenIntroFuture = Future.value(true);
    });
  }

  Future<void> _markUserAsLoggedIn(bool loggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, loggedIn);
    setState(() {
      _isUserLoggedInFuture = Future.value(loggedIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Auto Repair App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF43B02A),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        textTheme: GoogleFonts.urbanistTextTheme(
          Theme.of(context).textTheme, // preserve other theme text styling
        ),
        cardTheme: CardThemeData(
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF43B02A), width: 2.0),
          ),
          hintStyle: GoogleFonts.urbanist(color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _userHasSeenIntroFuture,
        builder: (context, introSnapshot) {
          if (introSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF43B02A)),
              ),
            );
          } else if (introSnapshot.hasError) {
            return const IntroScreen();
          } else {
            final bool hasSeenIntro = introSnapshot.data ?? false;
            if (hasSeenIntro) {
              return FutureBuilder<bool>(
                future: _isUserLoggedInFuture,
                builder: (context, loginSnapshot) {
                  if (loginSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(color: Color(0xFF43B02A)),
                      ),
                    );
                  } else {
                    final bool isLoggedIn = loginSnapshot.data ?? false;
                    return isLoggedIn ? const DashboardScreen() : _buildSignInScreen(context);
                  }
                },
              );
            } else {
              return const IntroScreen();
            }
          }
        },
      ),
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            // Handle route with parameters
            final uri = Uri.parse(settings.name ?? '');
            final path = uri.path.isEmpty ? '/' : uri.path;
            
            switch (path) {
              case '/intro':
                return const IntroScreen();
              case '/welcome':
                return _buildWelcomeScreen(context);
              case '/signin':
                return _buildSignInScreen(context);
              case '/signup':
                final fromWelcome = uri.queryParameters['fromWelcome'] == 'true';
                return _buildSignUpScreen(context, showBackButton: !fromWelcome);
              case '/dashboard':
                return const DashboardScreen();
              default:
                return const IntroScreen();
            }
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            var curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
      },
    );
  }

  Widget _buildWelcomeScreen(BuildContext context) {
    return WelcomeScreen(
      onGetStarted: () {
        _markIntroAsSeen();
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/signup?fromWelcome=true',  // Add a parameter to indicate source
          (route) => false,
        );
      },
      onSignIn: () {
        _markIntroAsSeen();
        Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
      },
    );
  }

  Widget _buildSignInScreen(BuildContext context) {
    return SignInScreen(
      onSignIn: (email, password) {
        print('Attempting Sign In: $email');
        _markUserAsLoggedIn(true);
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
      },
      onSignUp: () {
        Navigator.pushNamed(context, '/signup');
      },
      onForgotPassword: () {
        print('Forgot Password Tapped');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent to your email!'),
            backgroundColor: Color(0xFF43B02A),
          ),
        );
      },
    );
  }

  Widget _buildSignUpScreen(BuildContext context, {bool showBackButton = true}) {
    return SignUpScreen(
      onSignUp: (email, password) {
        print('Attempting Sign Up: $email');
        Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
      },
      onSignIn: () {
        Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
      },
      showBackButton: showBackButton,
    );
  }
}