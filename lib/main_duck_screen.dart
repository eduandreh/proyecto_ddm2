import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/shop_screen.dart';
import 'package:proyecto_ddm2/signin_screen.dart';
import 'package:proyecto_ddm2/weather_api_manager.dart';
import 'Duffy.dart';
import 'firebase_manager.dart';

class MainDuck extends StatefulWidget {
  const MainDuck({super.key});

  @override
  State<MainDuck> createState() => _MainDuck();
}

class _MainDuck extends State<MainDuck> {
  int _swipes = 0;
  List<String> backgroundImages = [];
  FirebaseManager fManager = FirebaseManager();
  String swipe = '';
  late Future<Duffy> duffyFuture;

  @override
  void initState() {
    duffyFuture = setDuck();
    super.initState();
    saveAppOpenTime();
    getImages();
  }

  Future<Duffy> setDuck() {
    return Future(() => getDuck());
  }

  Future<Duffy> getDuck() async {
    Duffy duck = await fManager.getDuck();
    return duck;
  }

  Future<String> setWeather(Duffy duck) async {
      return Future(() => getCurrentWeather(duck.location));
  }

  void getImages() async {
    backgroundImages = await fManager.getImagesURL("/backgrounds");
  }

  void _incrementSwipes() {

    _swipes = _swipes + 1;
    if (_swipes == 10) {
      fManager.incrementDuffyField("Coins", 1);
      fManager.incrementDuffyField("Duckiness", 0.5);

      setState(() {
        duffyFuture = setDuck();
      });
      _swipes = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: duffyFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && backgroundImages.isNotEmpty) {
            var duffy = snapshot.data;
            Future<String> weatherFuture = setWeather(duffy!);
            //_duffyWeather = duffy;
            return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  bottom: const PreferredSize(preferredSize: Size.fromHeight(0), child: SizedBox()),
                  leading: IconButton(
                    onPressed: () {
                      signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    },
                    icon: const Icon(Icons.logout_rounded,
                        color: Color(0xffDD8A29)),
                  ),
                  leadingWidth: 50,
                  title: Text(
                    duffy.location,
                    style:
                        const TextStyle(fontSize: 18, color: Color(0xff7e7e7e)),
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
                          duffy.coins.toString(),
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
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder(
                              future: weatherFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final icon = snapshot.data.toString();

                                  return Image.asset(
                                    icon,
                                    color: Colors.orange,
                                    height: 30,
                                  );
                                } else {
                                  return Image.asset(
                                    "assets/weather/6sun_icon.png",
                                    color: Colors.orange,
                                  );
                                }
                              }),

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
                                    value: duffy.duckiness == 0.0 ? 0.0 : duffy.duckiness / 100,
                                    backgroundColor: Colors.grey[300],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color(0xffDD8A29)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
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
                                  style: TextStyle(
                                      fontSize: 24, color: Color(0xff9C4615))),
                              const SizedBox(width: 12),
                              Text(duffy.life != 0 ? duffy.life.toString() : "0",
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
                                  child: Visibility(
                                      visible: backgroundImages.isNotEmpty
                                          ? true
                                          : false,
                                      child:
                                          Image.network(backgroundImages[0], width: 380))),
                              SizedBox(
                                height: 350,
                                child: Align(
                                  alignment: Alignment.center,
                                  child:
                                    //weather icon
                                    Image.network(duffy.outfit, width: 200),
                                ),
                              ),
                              SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: GestureDetector(
                                    onPanUpdate: (details) {
                                      if (details.delta.dx > 4) {
                                        swipe = 'right';
                                      } else if (details.delta.dx < 4) {
                                        swipe = 'left';
                                      }
                                    },
                                    onPanEnd: (details) {
                                      if (swipe == 'right' || swipe == 'left') {
                                        _incrementSwipes();
                                      }
                                    },
                                  ))
                            ],
                          ),
                        ])
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
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShopScreen(
                                  onDuckUpdated:(duffyUpt) {
                                    if(duffyUpt != null ){
                                      setState(() {
                                        duffyFuture = Future.value(duffyUpt);
                                      });
                                    }
                                  }
                                )));
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Stack(alignment: Alignment.center, children: <Widget>[
              Container(
                color: const Color(0xffBBDBBC),
              ),
              Image.asset("assets/placeholders/duck_placeHolder.png")
            ]);
          }
        });
  }
}
