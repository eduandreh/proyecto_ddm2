import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_ddm2/DuffyAccessory.dart';

class Duffy {
  final String name;
  final String location;
  late final String outfit;
  final int mallards;
  final int life;
  final double duckiness;
  final String color;
  dynamic accessories = List<DuffyAccessory>;
  final Timestamp lastConnection;
  final Timestamp created_at;


  Duffy(
      {required this.name, required this.location, required this.outfit, required this.mallards, required this.life, required this.duckiness, required this.accessories, required this.color, required this.lastConnection, required this.created_at});

  factory Duffy.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception("Document data is null!");
    }

    return Duffy(
      name: data['Name'] ?? '',
      location: data['Location'] ?? '',
      outfit: data['Outfit'] ?? '',
      mallards: data['Mallards'] ?? 0,
      life: data['Life'] ?? 100,
      duckiness: data['Duckiness']?.toDouble() ?? 0.0,
      lastConnection: data['Last_connection'] ?? '',
      created_at: data['Created_at'] ?? '',
      color: data['Color'] ?? '',
      accessories: data['Accessories'] ?? [],
    );
  }
}




