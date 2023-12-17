import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseManager {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  /*Future<String> checkUser(mail, password) async {
    String loginInfo = await signUp(mail, password);
    return loginInfo;
  }*/

  //signUp
  /*Future<String> signUp(mail, password) async {
    //try catch
    try {
      await auth.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
      CollectionReference usersCollection = db.collection('users');
      usersCollection
          .doc(auth.currentUser?.uid ?? '')
          .set({'mail': mail}).then((value) => print("Users Document Added"));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return logIn(mail, password);
      }
    }
    return '';
  }

  //logIn
  Future<String> logIn(mail, password) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: mail, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return 'Wrong password provided for that user.';
    }
    return '';
  }*/


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

}
