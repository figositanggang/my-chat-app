import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_chat_app/firebase/firebase_firestore_helper.dart';

class FirebaseStorageHelper {
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // Pick Image
  static Future<void> pickImage({
    required TargetPlatform platform,
    required String currentUserId,
  }) async {
    late Reference ref;

    ImagePicker picker = ImagePicker();
    XFile? webImage;

    if (kIsWeb) {
      webImage = await picker.pickImage(source: ImageSource.gallery);

      if (webImage != null) {
        String imageName = "${currentUserId}-profilePicture-${webImage.name}";
        ref = FirebaseStorage.instance.ref("Profile pictures").child(imageName);

        uploadImage(
          ref: ref,
          webImage: webImage,
          currentUserId: currentUserId,
        );
      }
    }
  }

  // Upload Image
  static Future uploadImage({
    required Reference ref,
    required XFile webImage,
    required String currentUserId,
  }) async {
    if (kIsWeb) {
      try {
        Uint8List imageBytes = await webImage.readAsBytes();
        TaskSnapshot taskSnapshot = await ref.putData(imageBytes);

        if (taskSnapshot.state == TaskState.success) {
          String photoUrl = await taskSnapshot.ref.getDownloadURL();

          await FirebaseFirestoreHelper.updatePhotoUrl(
            currentUserId: currentUserId,
            photoUrl: photoUrl,
          );

          print("Berhasil Upload");
        }
      } on FirebaseAuthException catch (e) {
        print("ERROOOOOOR: $e");
      }
    }
  }
}
