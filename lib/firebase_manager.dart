import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:proyecto_ddm2/DuffyAccessory.dart';

import 'Duffy.dart';
import 'Shop.dart';

class FirebaseManager {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<String>> getImagesURL(folderPath) async {
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

  Future<List<DuffyAccessory>> getDefaultAccessories() async {
    List<DuffyAccessory> duffyAccessories = [];

    final ref = db.collection("accessories").withConverter(
        fromFirestore: DuffyAccessory.fromFirestore,
        toFirestore: (DuffyAccessory duffyAccessory, _) => duffyAccessory.toFirestore());

    var querySnapshot = await ref.get();

    for (var snapshot in querySnapshot.docs) {
      if (snapshot != null) {
        duffyAccessories.add(snapshot.data());
      }
    }

    return duffyAccessories;
  }

  void updateDuckinessWithSwipes() {
    //get ducks duckiness

  }

  void getCoordsByCity(){

  }

  Future<Duffy> getDuck() async {
    var userId = auth.currentUser!.uid;

    Duffy duffy;
    final doc = await db.collection("duffy").doc(userId).get();
    duffy = Duffy.fromFirestore(doc);

    return duffy;
  }


}
