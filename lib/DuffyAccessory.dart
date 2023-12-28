import 'package:cloud_firestore/cloud_firestore.dart';

class DuffyAccessory {

  final String name;
  final bool sold;
  final bool gotten;

  DuffyAccessory(
      {required this.name, required this.sold, required this.gotten});

  factory DuffyAccessory.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options, ) {

    final data = snapshot.data()!;

    return DuffyAccessory(
      name: data?['name'],
      sold: data?['sold'],
      gotten: data?['gotten'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      if(name != null) "name": name,
      if(sold != null) "sold": sold,
      if(gotten != null) "gotten": gotten,
    };
  }
}
