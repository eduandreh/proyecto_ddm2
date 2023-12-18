import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'Shop.dart';

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

  Future<List<Shop>> getShop() async {
    List<Shop> shopObjects = [];

    final ref = db.collection("shop").withConverter(
        fromFirestore: Shop.fromFirestore,
        toFirestore: (Shop shop, _) => shop.toFirestore());

    var querySnapshot = await ref.get();

    for (var snapshot in querySnapshot.docs) {
      if (snapshot != null) {
        shopObjects.add(snapshot.data());
      }
    }

    return shopObjects;
  }
  void updateDuckinessWithSwipes() {
    //get ducks duckiness

  }

  void getCoordsByCity(){

  }

}
