import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/shop.dart';
import 'package:proyecto_ddm2/signin_screen.dart';
import 'package:proyecto_ddm2/weather_api_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Duffy.dart';
import 'firebase_manager.dart';

class MainDuck extends StatefulWidget {
  //needs to get duck object from login
  const MainDuck({super.key});

  //const MainDuck({super.key, required Duck duck});

  @override
  State<MainDuck> createState() => _MainDuck();
}

class _MainDuck extends State<MainDuck> {
  int _swipes = 0;
  List<String>backgroundImages =[];

  FirebaseManager fManager = FirebaseManager();

  @override
  void initState() {
    super.initState();
    getCurrentWeather(48.856613, 2.352222); //need duck's location
    getImages();
  }

  void getImages() async {
    backgroundImages = await fManager.getImagesURL("/backgrounds");
    setState(() {});
  }

  void _incrementSwipes() {
    setState(() {
      _swipes++;
      if(_swipes == 10) {
        fManager.updateDuckinessWithSwipes();
        //fManager.updateDuckinessWithSwipes(duck.duckiness);
        _swipes = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
            },
            icon: const Icon(Icons.logout_rounded, color: Color(0xffDD8A29)),
          ),
          leadingWidth: 50,
          title: const Text(
            "Alaska",
            style: TextStyle(fontSize: 18, color: Color(0xff7e7e7e)),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 30),
                Transform.rotate(
                  angle: 3.14159 / 2,
                  child: const Text(
                    'M',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff9C4615),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                const Text(
                  "359",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ]),
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

            return Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            //weather icon
            Container(
              height: 0,
              child: IconButton(
                icon: const Icon(Icons.ac_unit_outlined),
                color: Colors.orange,
                onPressed: () {},
              ),
            ),


            const SizedBox(height: 32),
            //progress bar
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 300,
                    height: 30,
                    child: LinearProgressIndicator(
                      value: duffy.duckiness / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xffDD8A29)),
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "DUCKINESS",
                    style: TextStyle(
                        color: Color(0xff236A26),
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),
            Text(duffy.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                )),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("D",
                    style: TextStyle(fontSize: 24, color: Color(0xff9C4615))),
                const SizedBox(width: 12),
                Text(duffy.life.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                    )),
              ],
            ),
            Visibility(visible: NetworkImage(duffy.outfit).url.isEmpty && backgroundImages.isEmpty ? true: false,
              child: Image(image: Image.asset("assets/placeholders/duck_placeHolder.png").image)),

            Visibility(visible: NetworkImage(duffy.outfit).url.isNotEmpty && backgroundImages.isNotEmpty ? true : false,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image(  //weather icon
                        image: NetworkImage(backgroundImages[0]),
                        width: 400,
                      ),
                    ),
                    SizedBox(height: 350, child: Align(
                      alignment: Alignment.center,
                      child: Image(  //weather icon
                        image: NetworkImage(duffy.outfit),
                        width: 200,
                      ),
                    ),),

                    SizedBox(
                        width: 300,
                        height: 300,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            if (details.delta.dx > 0) {
                              _incrementSwipes;
                            } else if (details.delta.dx < 0) {
                              _incrementSwipes;
                            }
                          },
                        ))
                  ],
                ),)

          ]));
          } else {
            return Text('No hay Duffy disponible');
          }
        },
      ),

      bottomNavigationBar: BottomAppBar(
        color: const Color(0xffBBDBBC),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text("Let your Duffy be!",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                )),
            IconButton(
              icon: const Icon(Icons.add_business),
              color: Colors.orangeAccent,
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Shop()));},
            ),
          ],
        ),
      ),
    );
  }
}
