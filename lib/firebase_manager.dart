import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseManager {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<String>> getImagesURL(folderPath) async {

    print("entro!!!!!");
    // Get a reference to the folder
    Reference folderRef = storage.ref().child(folderPath);
    List<String> urlList = [];

    ListResult result = await folderRef.listAll();

      for (Reference item in result.items) {
        String downloadURL = await item.getDownloadURL();
        print('Image URL: $downloadURL');
        urlList.add(downloadURL);
      }

    return urlList;
  }

  void updateDuckinessWithSwipes() {
    //get ducks duckiness

  }

  void getCoordsByCity(){

  }
  //get coords by city name

}
