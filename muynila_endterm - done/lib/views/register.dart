import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:muynila_endterm/views/BackgroundRemoveScreen.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formkey = GlobalKey<FormState>();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPassword = TextEditingController();
  bool obscurePassword = true;
  void validateInput() {
    if (formkey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: null,
        title: 'Are you sure?',
        confirmBtnText: 'YES',
        cancelBtnText: 'No',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          signUp();
        },
      );
    }
  }

  void signUp() async {
    try {
      EasyLoading.show(
        status: 'Processing...',
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'null-usercredential');
      }
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': usernameController.text,
      });

      EasyLoading.showSuccess('User account has been registered.');
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const RemoveBackgroundScreen(),
        ),
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        EasyLoading.showError(
            'Your password is weak. Please enter more than 6 characters.');
        return;
      }
      if (ex.code == 'email-already-in-use') {
        EasyLoading.showError(
            ('Your email is already registered. Please enter a new email address.'));
        return;
      }
      if (ex.code == 'null-usercredential') {
        EasyLoading.showError(
            'An error occurred while creating your account. Please try again');
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
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
                  const SizedBox(height: 80.0),
                  Image.asset(
                    'assets/images/clear-cut.png',
                    height: 80,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required. Please enter your username.';
                      }
                      return null;
                    },
                    controller: usernameController,
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
                      labelText: 'Username',
                      hintText: 'Enter your Username',
                    ),
                  ),
                  const SizedBox(height: 20.0),
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
                      label: Text("Email"),
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
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required. Please enter your password.';
                      }
                      if (value != passwordController.text) {
                        return 'Password do not match! try again';
                      }
                      return null;
                    },
                    controller: confirmPassword,
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
                      labelText: 'Confirm your password',
                      hintText: 'Confirm your password',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: validateInput,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an accont?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return const LoginScreen();
                          }));
                        },
                        child: const Text(
                          'Login',
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
