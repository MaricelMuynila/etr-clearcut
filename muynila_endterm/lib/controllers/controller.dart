import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:http/http.dart' as http;

class RemoveBackgroundController extends GetxController {
  Uint8List? imageFile;
  String? imagePath;
  ScreenshotController controller = ScreenshotController();
  var isLoading = false.obs;

  Future<Uint8List> removeBackground(String? imagePath) async {
    isLoading.value = true;
    update();

    var request = http.MultipartRequest(
        "POST", Uri.parse("https://api.remove.bg/v1.0/removebg"));
    request.files
        .add(await http.MultipartFile.fromPath("image_file", imagePath!));
    request.headers.addAll({"X-API-Key": "JzCFpCdsAPMZWUun5aauHEGS"});
    final response = await request.send();
    if (response.statusCode == 200) {
      http.Response imageResponse = await http.Response.fromStream(response);
      isLoading.value = false;
      update();
      return imageResponse.bodyBytes;
    } else {
      throw Exception("Error");
    }
  }

  void pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imagePath = pickedImage.path;
        imageFile = await pickedImage.readAsBytes();
        update();
      }
    } catch (e) {
      imageFile = null;
      update();
    }
  }

  void cleanUp() {
    imageFile = null;
    update();
  }

  void saveImage() async {
    bool isStorageGranted = await Permission.storage.isGranted;
    if (!isStorageGranted) {
      isStorageGranted = (await Permission.storage.request()).isGranted;
    }
    if (isStorageGranted) {
      final directory = (await getExternalStorageDirectory())!.path;
      final fileName = "${DateTime.now().microsecondsSinceEpoch}.png";

      controller
          .captureAndSave('storage/emulated/0/Download/removed-bg',
              fileName: fileName)
          .then((imagePath) {
        print('Image saved successfully: $imagePath');
      }).catchError((error) {
        print('Error saving image: $error');
      });
    }
  }
}
