import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muynila_endterm/views/welcome_screen.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:screenshot/screenshot.dart';

import '../controllers/controller.dart';

class RemoveBackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GetBuilder<RemoveBackgroundController>(
            init: RemoveBackgroundController(),
            builder: (controller) {
              return Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: MoreGradientColors.azureLane,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Image.asset(
                              'assets/images/clear-cut.png',
                              height: 50,
                            ),
                          ),
                          const SizedBox(),
                          IconButton(
                            onPressed: () {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                text: 'Do you want to logout',
                                confirmBtnText: 'Yes',
                                cancelBtnText: 'No',
                                confirmBtnColor: Colors.green,
                                onConfirmBtnTap: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                },
                                onCancelBtnTap: () {
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            icon: Icon(
                              Icons.exit_to_app,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      (controller.imageFile != null)
                          ? Column(
                              children: [
                                Container(
                                  height: 500,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Screenshot(
                                        controller: controller.controller,
                                        child: Image.memory(
                                          controller.imageFile!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Card(
                                  elevation: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => controller.isLoading.value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : TextButton(
                                                  onPressed: () async {
                                                    if (controller.imageFile ==
                                                        null) {
                                                      Get.snackbar(
                                                        "Error",
                                                        "Select an image",
                                                      );
                                                    } else {
                                                      controller.imageFile =
                                                          await controller
                                                              .removeBackground(
                                                        controller.imagePath!,
                                                      );
                                                      print("Success");
                                                      controller.update();
                                                    }
                                                    controller.update();
                                                  },
                                                  child: Column(
                                                    children: const [
                                                      Icon(
                                                        Icons.content_cut,
                                                        size: 20,
                                                        color: Colors.black,
                                                      ),
                                                      Text(
                                                        "Remove",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller.cleanUp();
                                            controller.pickImage(
                                              ImageSource.gallery,
                                            );
                                          },
                                          child: Column(
                                            children: const [
                                              Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                "Add new image",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (controller.imageFile != null) {
                                              controller.saveImage();
                                              Get.snackbar(
                                                "Success",
                                                "Image saved successfully",
                                              );
                                              print(controller.imagePath);
                                            } else {
                                              Get.snackbar(
                                                "Error",
                                                "Image saving failed",
                                              );
                                            }
                                          },
                                          child: Column(
                                            children: const [
                                              Icon(
                                                Icons.save_alt,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                "Save",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            )
                          : Column(
                              children: [
                                const SizedBox(height: 100),
                                Container(
                                  height: 300,
                                  width: 270,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.image,
                                    size: 100,
                                    color: Colors.grey[900],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Text(
                                  'Choose an Image',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.pickImage(
                                          ImageSource.gallery,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.image,
                                        color: Colors.grey[800],
                                        size: 40,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller.pickImage(
                                          ImageSource.camera,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
