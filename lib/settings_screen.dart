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
       backgroundColor: const Color.fromARGB(221, 255, 255, 255),
        title: const Text('Ajustes', style: const TextStyle(
                            
                            )),
      ),
      body:
    
       Padding(
        
        padding: const EdgeInsets.all(10.0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            
            const SizedBox(height: 50), 

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
           child: ElevatedButton(
              
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
            ),
            
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
           child: ElevatedButton(
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
            ),
            SizedBox(height: 300),
            SizedBox(
              height: 100,
              child: Image(
                  image: Image.asset("assets/placeholders/duckYellow.png").image,
                  height: 100,
                  width: 100),
            ),
          ],
        ),
      ),
    );
  }
}
