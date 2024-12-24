import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true; // Toggle between login and signup
  bool rememberMe = false; // Remember me option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101015), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50), // Space from the top
            Text(
              isLogin ? "Login" : "Sign Up",
              style: TextStyle(
                fontFamily: 'ProtoMono',
                fontSize: 32,
                color: Color(0xFFF1F0E1),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            _buildTextField("Email", Icons.email, false, _emailController),
            SizedBox(height: 20),
            _buildTextField("Password", Icons.lock, true, _passwordController),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),
                Text(
                  "Remember Me",
                  style: TextStyle(
                    color: Color(0xFFF1F0E1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            _buildActionButton(),
            SizedBox(height: 20),
            _buildToggleText(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData icon, bool isObscure, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(
        fontFamily: 'ProtoMono',
        color: Color(0xFFF1F0E1),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFFF1F0E1).withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Color(0xFFF1F0E1)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF506385)), // Border color
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF628550)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          if (isLogin) {
            // Login
            UserCredential userCredential = await _auth.signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

            // Save credentials if "Remember Me" is checked
            if (rememberMe) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('email', _emailController.text.trim());
              await prefs.setString('password', _passwordController.text.trim());
            }

            // Navigate to Pattern Lock Screen
            Navigator.pushReplacementNamed(context, '/pattern_lock');
          } else {
            // Sign Up
            UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

            // Navigate to Login Screen for verification
            Navigator.pushReplacementNamed(context, '/login_signup');
          }
        } on FirebaseAuthException catch (e) {
          // Handle specific Firebase exceptions
          String message;
          if (e.code == 'user-not-found') {
            message = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            message = 'Wrong password provided for that user.';
          } else {
            message = 'An error occurred. Please try again.';
          }
          // Show error message to the user
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        } catch (e) {
          // Handle any other exceptions
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An unexpected error occurred.')));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isLogin ? Color(0xFF506385) : Color(0xFF855063),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: TextStyle(
          fontFamily: 'ProtoMono',
          fontSize: 18,
        ),
      ),
      child: Center(
        child: Text(isLogin ? "Login" : "Sign Up"),
      ),
    );
  }

  Widget _buildToggleText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? "Don't have an account? " : "Already have an account? ",
          style: TextStyle(
            fontFamily: 'ProtoMono',
            fontSize: 16,
            color: Color(0xFFF1F0E1),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isLogin = !isLogin;
            });
          },
          child: Text(
            isLogin ? "Sign Up" : "Login",
            style: TextStyle(
              fontFamily: 'ProtoMono',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF857250), // Highlight color
            ),
          ),
        ),
      ],
    );
  }
}
