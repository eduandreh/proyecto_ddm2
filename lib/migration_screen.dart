import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/duck_creator_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tu Duffy ha Migrado!',
      home: MigrationScreen(),
    );
  }
}

class MigrationScreen extends StatelessWidget {
  const MigrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           
            Image.network(
              'https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/plainDucks%2FMigration%20duck.png?alt=media&token=47c31628-6c2f-4962-aa94-0f51f8cb84bd', // Reemplaza con tu ruta de imagen
              width: screenSize.width * 0.8, 
              height: screenSize.height * 0.3, 
            ),
            const SizedBox(height: 20),
            
            const Text(
              '¡Tu Duffy ha emigrado!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'No has cuidado bien a tu Duffy, y su duckiness ha bajado a 0, por lo que ha decidido migrar a otro lugar mejor. \nPero no te preocupes, puedes comenzar de nuevo creando un nuevo Duffy.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
          
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              onPressed: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DuckCreator()),
                );
              },
              child: const Text('Crear un nuevo Duffy'),
            ),
          ],
        ),
      ),
    );
  }
}
