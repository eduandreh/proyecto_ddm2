import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_ddm2/DuffyAccessory.dart';

class Duffy {
  final String name;
  final String location;
  late final String outfit;
  final int coins;
  final int life;
  final double duckiness;
  final String color;
  dynamic accessories = List<DuffyAccessory>;
  final Timestamp lastConnection;


  Duffy(
      {required this.name, required this.location, required this.outfit, required this.coins, required this.life, required this.duckiness, required this.accessories, required this.color, required this.lastConnection});

  factory Duffy.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Duffy(
      name: data['Name'] ?? '',
      location: data['Location'] ?? '',
      outfit: data['Outfit'] ?? '',
      coins: data['Coins'] ?? 0,
      life: data['Life'] ?? 100,
      duckiness: data['Duckiness']?.toDouble() ?? 0.0,
      lastConnection: data['Last_connection'] ?? '',
      color: data['Color'] ?? '',
      accessories: data['Accessories'] ?? [],
    );
  }
}




