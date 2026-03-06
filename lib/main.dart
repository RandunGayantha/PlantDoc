import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlantDoc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

//////////////////////////////////////////////////////
// SPLASH SCREEN
//////////////////////////////////////////////////////

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const NavigationPage()));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 120, color: Colors.green),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////
// LOGIN PAGE
//////////////////////////////////////////////////////

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future login() async {
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      if (!mounted) return;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavigationPage()));

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Login Error")));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(90)),
              ),
              child: const Center(
                  child: Icon(Icons.eco, size: 100, color: Colors.white)),
            ),

            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [

                  const Text("Welcome Back",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),

                  const SizedBox(height: 30),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text("LOGIN",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignupPage()));
                      },
                      child: const Text("New User? Create Account"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////
// SIGNUP PAGE
//////////////////////////////////////////////////////

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signup() async {
    try {

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      if (!mounted) return;
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Signup Error")));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [

            const Icon(Icons.person_add,
                size: 80, color: Colors.green),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: signup,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text("SIGN UP",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////
// NAVIGATION PAGE
//////////////////////////////////////////////////////

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  int index = 0;

  final pages = [
    const DashboardPage(),
    const Center(child: Text("Map Page")),
    const Center(child: Text("Camera Page")),
    const Center(child: Text("Forum Page")),
    const Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Camera"),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: "Forum"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////
// DASHBOARD
//////////////////////////////////////////////////////

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("PlantDoc Dashboard"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
          child: Text("Welcome to PlantDoc 🌿",
              style: TextStyle(fontSize: 20))),
    );
  }
}