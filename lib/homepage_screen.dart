import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/duck_creator_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('duffy').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); //inidicador de carga
          }
          if (snapshot.hasError) {
            return Text('Error al cargar los datos');
          }
          if (snapshot.hasData && snapshot.data != null) {
            Duffy duffy = Duffy.fromFirestore(snapshot.data!);
            return Column(
              children: [
                Image.network(duffy.color),
                Text(duffy.name),
                Text(duffy.location),
              ],
            );
          } else {
            return Text('No hay Duffy disponible');
          }
        },
      ),
    );
  }
}