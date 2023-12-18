import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_ddm2/DuffyAccessory.dart';

class Duffy {
  final String name;
  final String location;
  final String outfit;
  final double coins;
  final double life;
  final double duckiness;


  Duffy(
      {required this.name, required this.location, required this.outfit, required this.coins, required this.life, required this.duckiness});

  factory Duffy.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Duffy(
      name: data['Name'] ?? '',
      location: data['Location'] ?? '',
      outfit: data['Outfit'] ?? '',
      coins: data['Coins']?.toDouble() ?? 0.0,
      life: data['Life']?.toDouble() ?? 100.0,
      duckiness: data['Duckiness']?.toDouble() ?? 0.0,
    );
  }
}