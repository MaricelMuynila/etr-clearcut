import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muynila_endterm/views/register.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: MoreGradientColors.azureLane,
          )),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 130,
                ),
                Image.asset(
                  'assets/images/clear-cut.png',
                  height: 100,
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40),
                  child: Text(
                    'Unleash Your Creativity with the Ultimate Background Remover, Making Editing Effortless and Brilliantly Seamless!',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return const LoginScreen();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.montserrat(color: Colors.black),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return const RegisterScreen();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Register',
                      style: GoogleFonts.montserrat(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
