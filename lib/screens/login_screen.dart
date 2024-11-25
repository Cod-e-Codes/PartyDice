import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/party_dice_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return e.message; // Handle other errors
    } catch (e) {
      return 'An error occurred. Please try again later.';
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name ?? '', // Ensure email is not null
        password: data.password ?? '', // Ensure password is not null
      );
      return null; // Registration successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message; // Handle other errors
    } catch (e) {
      return 'An error occurred. Please try again later.';
    }
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
      return null; // Password reset email sent
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      }
      return e.message; // Handle other errors
    } catch (e) {
      return 'An error occurred. Please try again later.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'PartyDice',
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const PartyDiceScreen(),
        ));
      },
      theme: LoginTheme(
        primaryColor: Colors.deepPurpleAccent,
        accentColor: Colors.amber,
        errorColor: Colors.deepOrange,
        buttonStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Bungee', // Match your app's font
        ),
        textFieldStyle: const TextStyle(
          color: Colors.black, // Change text color to black for better visibility
          fontFamily: 'RampartOne', // Match your app's font
        ),
        titleStyle: TextStyle(
          color: Colors.amber,
          fontFamily: 'MochiyPopOne', // Match your app's font
          fontSize: 36,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 0.0.r,
              color: Colors.red.shade900,
              offset: Offset(4.0.w, 4.0.h),
            ),
            Shadow(
              blurRadius: 0.0.r,
              color: Colors.black,
              offset: Offset(2.0.w, 2.0.h),
            ),
            Shadow(
              blurRadius: 0.0.r,
              color: Colors.black,
              offset: Offset(-2.w, -2.h),
            ),
            Shadow(
              blurRadius: 0.0.r,
              color: Colors.black,
              offset: Offset(-2.w, 2.h),
            ),
            Shadow(
              blurRadius: 0.0.r,
              color: Colors.black,
              offset: Offset(2.w, -2.h),
            ),
          ],
        ),
        bodyStyle: const TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'Satisfy', // Match your app's font
        ),
        footerTextStyle: const TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'Satisfy', // Match your app's font
        ),
        logoWidth: 100.0, // Example logo width
        primaryColorAsInputLabel: false,
        cardTheme: CardTheme(
          color: Colors.deepPurple,
          elevation: 5.sp,
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.amber, // Set background color of input fields
          labelStyle: TextStyle(
            color: Colors.red.shade900, // Label text color
          ),
          hintStyle: const TextStyle(
            color: Colors.grey, // Hint text color
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(24.0.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(24.0.r),
          ),
        ),
      ),
    );
  }
}
