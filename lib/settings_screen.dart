import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/Duffy.dart';
import 'package:proyecto_ddm2/duck_creator_screen.dart';
import 'package:proyecto_ddm2/signin_screen.dart';
import 'package:proyecto_ddm2/firebase_manager.dart';

class SettingsScreen extends StatelessWidget {
  
  SettingsScreen({super.key});

FirebaseManager fManager = FirebaseManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(221, 138, 41, 1),
        title: const Text('Ajustes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            const SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () {
                fManager.deleteDuffy();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DuckCreator()));
              },
              child: const Text('Borrar Duffy'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(221, 138, 41, 1),
                onPrimary: Colors.white,
                onSurface: Colors.grey,
                minimumSize: const Size(double.infinity, 50), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                
                fManager.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignInScreen()));
            
              },
              child: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(221, 138, 41, 1),
                onPrimary: Colors.white,
                onSurface: Colors.grey,
                minimumSize: const Size(double.infinity, 50), 
                shape: RoundedRectangleBorder( 
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
