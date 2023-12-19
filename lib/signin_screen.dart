import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/duck_creator_screen.dart';
import 'package:proyecto_ddm2/main_duck_screen.dart';
import 'package:proyecto_ddm2/signup_register.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Image(
                  image: Image.asset("assets/placeholders/duckYellow.png").image,
                  height: 100,
                  width: 100),
            ),
            const Text(
              'Bienvenid@!',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Text(
              'Logueate para ver a tu Duffy!',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
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
                // filled: true,
                // fillColor: Color.fromRGBO(221, 138, 41, 0.1),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    )
                    .then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainDuck())))
                    .catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se pudo iniciar sesión'),
                    ),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(221, 138, 41, 1),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                //width: MediaQuery.of(context).size.width * 0.5,
                child: const Text(
                  'Entrar >',
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
                    builder: (context) => const SignUpScreen(),
                  ),
                );
              },
              child: const Text('Nuevo en Duffy? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
