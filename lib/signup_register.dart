//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'duck_creator_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();

}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
              child: Image(
                  image: Image.asset("assets/placeholders/duckYellow.png").image,
                  height: 100,
                  width: 100),
            ),
            const Text(
              'Empezemos!',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
              
            ),
            const Text(
              'Quien cuidará a tu Duffy?',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailTextController,
              decoration: const InputDecoration(
                hintText: 'Correo electrónico',
                suffixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: _passwordTextController,
              
              decoration: const InputDecoration(
                hintText: 'Contraseña',
             
            suffixIcon: Icon(Icons.lock),
               
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: _confirmPasswordTextController,
              decoration: const InputDecoration(
        
                hintText: 'Confirmar contraseña',
                
                suffixIcon: Icon(Icons.lock),
              
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_passwordTextController.text != _confirmPasswordTextController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Las contraseñas no coinciden'),
                    ),
                  );
                }
                else if (_passwordTextController.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('La contraseña debe tener al menos 6 caracteres'),
                    ),
                  );
                  
                }
                else{
                FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _emailTextController.text,
                  password: _passwordTextController.text,
                ).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DuckCreator()))).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se pudo crear la cuenta'),
                    ),
                  );
                });
                }
              },
              
              style: ElevatedButton.styleFrom(
                 primary: const Color.fromRGBO(221, 138, 41, 1),
                 onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )
                  ),
               child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                //width: MediaQuery.of(context).size.width * 0.5,
                child: const Text(
                  'Siguiente >',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
               
                Navigator.push(
                  context,
                  
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                )
                );
            },
              child: const Text('Ya tienes a un Duffy? Logueate'),
            ),
          ],
        ),
      ),
    );
  }
}