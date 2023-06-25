import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:muynila_endterm/views/BackgroundRemoveScreen.dart';
import 'package:muynila_endterm/views/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  bool obscurePassword = true;
  var passwordController = TextEditingController();

  void login() async {
    if (formkey.currentState!.validate()) {
      EasyLoading.show(status: 'processing');
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((userCredential) async {
        EasyLoading.dismiss();
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const RemoveBackgroundScreen()));
      }).catchError((err) {
        EasyLoading.showError('Incorrect Email/Password, Try again');
      });
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: MoreGradientColors.azureLane,
        )),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back)),
                    ],
                  ),
                  const SizedBox(height: 100.0),
                  Image.asset(
                    'assets/images/clear-cut.png',
                    height: 80,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required. Please enter an email address.';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      labelStyle:
                          TextStyle(color: Color.fromARGB(242, 245, 245, 245)),
                      hintStyle:
                          TextStyle(color: Color.fromARGB(242, 245, 245, 245)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Email',
                      hintText: 'Enter your Email',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required. Please enter your password.';
                      }
                      if (value.length <= 6) {
                        return 'Password should be more than 6 characters.';
                      }
                      return null;
                    },
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                      ),
                      filled: true,
                      fillColor: Colors.white12,
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(242, 245, 245, 245)),
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(242, 245, 245, 245)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Password',
                      hintText: 'Enter your password',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: login,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Log In',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return const RegisterScreen();
                          }));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
