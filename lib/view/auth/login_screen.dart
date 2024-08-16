import 'package:flutter/material.dart';
import 'package:presensi_mobile/view/screen.dart';

import '../../models/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int? _userId;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final userData = await login(email, password);

    if (userData != null && userData.containsKey('id')) {
      setState(() {
        _userId = userData['id'] as int;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Screen(userId: _userId!), // Pass the userId to Screen widget
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login failed'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true, // Allow the scaffold to resize
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Selamat Datang!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        'assets/hero_banner.jpg',
                        width: 320, // Set the desired width
                        height: 320, // Set the desired height
                        // fit: BoxFit.cover, // Adjust the fit property as needed
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _login, // Change to call _login method
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                          elevation: 5, // Shadow elevation
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
