import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../../Dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_auth.dart';
import 'dart:developer' as devLog; // TODO: delete

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'IMAD FLUTTER IA',
      messages: LoginMessages(
        userHint: 'Login',
        passwordHint: 'password',
        confirmPasswordHint: 'Confirmer le mot de passe',
        loginButton: 'Se connecter',
        signupButton: 'S\'inscrire',
        forgotPasswordButton: 'Mot de passe oublié?',
        recoverPasswordButton: 'Récupérer',
        goBackButton: 'Retour',
        confirmPasswordError: 'Les mots de passe ne correspondent pas!',
        recoverPasswordIntro: 'Entrez l\'adresse e-mail associée à votre compte',
        recoverPasswordDescription:
        'Nous vous enverrons un e-mail pour réinitialiser votre mot de passe',
        recoverPasswordSuccess:
        'Un e-mail de récupération a été envoyé avec succès',
        flushbarTitleError: 'Erreur',
        flushbarTitleSuccess: 'Succès',
      ),
      theme: LoginTheme(
        primaryColor: Colors.blue, // Change the primary color
        accentColor: Colors.amber, // Change the accent color
        titleStyle: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 28.0,
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.amberAccent,
          backgroundColor: Colors.blue,
          highlightColor: Colors.tealAccent,
          elevation: 8.0,
          highlightElevation: 12.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textFieldStyle: TextStyle(
          color: Colors.black87,
          fontSize: 16.0,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 5.0,
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      onLogin: (loginData) => _handleLogin(context, loginData),
      onSubmitAnimationCompleted: () {
        // Handle after login animation completion if needed
      },
      onSignup: (_) {},
      onRecoverPassword: (_) {
        // Handle password recovery logic if needed
      },
    );
  }

  Future<String?> _handleLogin(
      BuildContext context, LoginData loginData) async {
    FirebaseAuthHelper _authHelper = FirebaseAuthHelper();

    UserCredential? userCredential =
    await _authHelper.signIn(loginData.name, loginData.password);

    if (userCredential != null) {
      // Navigate to the dashboard on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    }

    // If login fails, return an error message
    return "Login failed";
  }
}
