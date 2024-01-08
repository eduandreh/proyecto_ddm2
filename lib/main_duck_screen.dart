import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/settings_screen.dart';
import 'package:proyecto_ddm2/shop_screen.dart';
import 'package:proyecto_ddm2/signin_screen.dart';
import 'package:proyecto_ddm2/weather_api_manager.dart';
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
  List<String> backgroundImages = [];
  FirebaseManager fManager = FirebaseManager();
  Duffy? _duffy;

  @override
  void initState() {
    super.initState();
    saveAppOpenTime();
    getDuck();
    getCurrentWeather(48.856613, 2.352222); //need duck's location
    getImages();
  }

  void getDuck() async {
    _duffy = await fManager.getDuck();
    setState(() {});
  }

  void getImages() async {
    backgroundImages = await fManager.getImagesURL("/backgrounds");
    setState(() {});
  }

  void _incrementSwipes() {
    setState(() {
      _swipes++;
      if (_swipes == 10) {
        fManager.updateDuckinessWithSwipes();
        //fManager.updateDuckinessWithSwipes(duck.duckiness);
        _swipes = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
            icon: const Icon(Icons.settings, color: Color(0xffDD8A29)),
          ),
          leadingWidth: 50,
          title: Text(
            _duffy != null ? _duffy!.location : "Location",
            style: const TextStyle(fontSize: 18, color: Color(0xff7e7e7e)),
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
                Text(
                  _duffy != null ? _duffy!.coins.toString() : "000",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            )
          ]),
      body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            //weather icon
            Visibility(
                visible: _duffy == null ? true : false,
                child: Image(
                    image:
                        Image.asset("assets/placeholders/duck_placeHolder.png")
                            .image)),
            Visibility(
              visible: _duffy != null ? true : false,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                              value: _duffy == null ? 1 : _duffy!.duckiness / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xffDD8A29)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
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
                    Text(_duffy == null ? 'Duffy' : _duffy!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        )),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("D",
                            style: TextStyle(
                                fontSize: 24, color: Color(0xff9C4615))),
                        const SizedBox(width: 12),
                        Text(_duffy == null ? '' : _duffy!.life.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 28,
                            )),
                      ],
                    ),

                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image(
                              //weather icon
                              image: NetworkImage(backgroundImages[0]),
                              width: 400,
                            ),
                          ),
                          SizedBox(
                            height: 350,
                            child: Align(
                              alignment: Alignment.center,
                              child: Image(
                                //weather icon
                                image: _duffy == null ? Image.asset("assets/placeholders/duckYellow.png").image : NetworkImage(_duffy!.outfit),
                                width: 200,
                              ),
                            ),
                          ),
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
                      ),

                  ]),
            )
          ])),
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ShopScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
