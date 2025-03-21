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

  Future<void> saveAppOpenTime() async {
    var userID = auth.currentUser?.uid;
    if (userID != null) {
      var userActivityRef = db.collection("users").doc(userID);
      var now = DateTime.now();

      return await userActivityRef.set({
        'Last_connection': now,
      }, SetOptions(merge: true));
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  static bool isSignedIn() {
    return FirebaseAuth.instance.currentUser?.uid != null;
  }

Future<void> deleteDuffy() async {
  var userID = FirebaseAuth.instance.currentUser?.uid;
  if (userID != null) {
    var userActivityRef = FirebaseFirestore.instance.collection("users").doc(userID);
    return await userActivityRef.delete();
  }
}

  Future<List<String>> getImagesURL(folderPath) async {
    // Get a reference to the folder
    Reference folderRef = storage.ref().child(folderPath);
    List<String> urlList = [];
    ListResult result = await folderRef.listAll();

      for (Reference item in result.items) {
        String downloadURL = await item.getDownloadURL();
        urlList.add(downloadURL);
      }

    return urlList;
  }

  Future<String> getSpecificFile(folderPath,file) async {
    // Get a reference to the folder
    Reference folderRef = storage.ref().child(folderPath);
    String urlFile =
    await folderRef.child("/$file.png").getDownloadURL();

    return urlFile;
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

  Future<void> updateSoldBool(bought, name, isGotten) async {

    var ref = db.collection("users").doc(auth.currentUser?.uid);

    await ref.update({
      "Accessories": FieldValue.arrayRemove([{"gotten": isGotten, "name": name, "sold": !bought}]),
    }).then(
          (value) => print("$name successfully removed!"),
      onError: (e) => print("Error removing $name document $e"),
    );

    await ref.update({
        "Accessories": FieldValue.arrayUnion([{"gotten": true, "name": name, "sold": bought}]),
        }).then(
            (value) => print("$name successfully updated!"),
          onError: (e) => print("Error updating $name document $e"),
    );

  }

  Future<void> updateAccessoryImage(accessoryImage) async {
    var ref = db.collection("users").doc(auth.currentUser?.uid);

    await ref.update({
      "Outfit": accessoryImage,
    }).then(
          (value) => print("Duffy outfit successfully updated!"),
      onError: (e) => print("Error updating outfit document $e"),
    );
  }

  Future<void> incrementDuffyField(field, quantity) async {
    var ref = db.collection("users").doc(auth.currentUser?.uid);

    await ref.update({
      field: FieldValue.increment(quantity),
    }).then(
          (value) => print("$field successfully updated!"),
      onError: (e) => print("Error updating $field document $e"),
    );

  }

  Future<Duffy> getDuck() async {

    var userId = auth.currentUser!.uid;
    Duffy duffy;
    final doc = await db.collection("users").doc(userId).get();
    duffy = Duffy.fromFirestore(doc);
    return duffy;
  }
}
