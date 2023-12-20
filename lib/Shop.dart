import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {

  final int price;
  final String image;

  Shop(
      {required this.price, required this.image});

  factory Shop.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options, ) {
    final data = snapshot.data();

    return Shop(
      price: data?['price'],
      image: data?['image'],
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      if(price != null) "price": price,
      if(image != null) "image": image,
    };
  }
}
