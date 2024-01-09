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

  late Duffy? duffy;
  late String? weather;
  //late int? _mallards;
  //late double? _duckiness;

  late ValueNotifier<int?> _mallardsNotifier;
  late ValueNotifier<double?> _duckinessNotifier;

  @override
  void initState() {
    super.initState();
//    saveAppOpenTime();
    getImages();
    _mallardsNotifier = ValueNotifier<int?>(0);
    _duckinessNotifier = ValueNotifier<double?>(100.0);

  }

  Future<void> getDuffy() async {
    duffy = await fManager.getDuck();
    weather = await getCurrentWeather(duffy!.location);
    await updateDuckiness(duffy!, weather!);
    duffy = await fManager.getDuck();
    _mallardsNotifier.value = duffy!.coins;
   _duckinessNotifier.value = duffy!.duckiness;
  }

  void getImages() async {
    backgroundImages = await fManager.getImagesURL("/backgrounds");
  }

  void _incrementSwipes() {
    _swipes = _swipes + 1;
    if (_swipes == 3) {
      fManager.incrementDuffyField("Coins", 1);
      fManager.incrementDuffyField("Duckiness", 0.5);
      _swipes = 0;
      _mallardsNotifier.value = _mallardsNotifier.value! + 1;
      _duckinessNotifier.value = _duckinessNotifier.value! + 1;

    }
  }

  Future<void> updateDuckiness(Duffy duffy, String weather) async {
    Duration difference = DateTime.now()
        .difference(DateTime.parse(duffy.lastConnection.toDate().toString()));

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int totaHours = days * 24 + hours;
    if (days >= 1 || hours >= 1 && duffy.duckiness > 0) {
      fManager.saveAppOpenTime();
      double totalPenalty = 0;
      if (!duffy.outfit.contains("ball")) {
        if (weather.contains("hot") && !duffy.outfit.contains("Glasses") ||
            weather.contains("snow") && !duffy.outfit.contains("Scarf") ||
            weather.contains("wind") && !duffy.outfit.contains("Hat") ||
            weather.contains("rain") && !duffy.outfit.contains("Umb")) {
          totalPenalty = totaHours * 1.5;
        }
      }

      totalPenalty = totaHours * 0.5 + totalPenalty;
      if (duffy.duckiness - totalPenalty > 0) {
        await fManager.incrementDuffyField("Duckiness", -totalPenalty);
      } else {
        await fManager.incrementDuffyField("Duckiness", -duffy.duckiness);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDuffy(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              backgroundImages.isNotEmpty) {
            return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(0), child: SizedBox()),
                  leading: IconButton(
                    onPressed: () {
                      fManager.signOut();
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
                    duffy!.location,
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
                        ValueListenableBuilder<int?>(
                          valueListenable: _mallardsNotifier,
                          builder: (context, mallards, _) {
                            return Text(
                              mallards?.toString() ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
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
                          Image.asset(
                            weather!,
                            color: Colors.orange,
                            height: 30,
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
                                  child: ValueListenableBuilder<double?>(
                                    valueListenable: _duckinessNotifier,
                                    builder: (context, duckiness, _) {
                                      return LinearProgressIndicator(
                                        value: duckiness == 0.0 || duckiness == null
                                            ? 0.0
                                            : duckiness / 100,
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color(0xffDD8A29)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30)),
                                      );
                                    },
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
                          Text(duffy!.name,
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
                              Text(
                                  duffy!.life != 0
                                      ? duffy!.life.toString()
                                      : "0",
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
                                      child: Image.network(backgroundImages[0],
                                          width: 380))),
                              SizedBox(
                                height: 350,
                                child: Align(
                                  alignment: Alignment.center,
                                  child:
                                      //weather icon
                                      Image.network(duffy!.outfit,
                                          fit: BoxFit.fitWidth),
                                ),
                              ),
                              SizedBox(
                                  width: 300,
                                  height: 300,
                                  child:
                                      GestureDetector(onPanUpdate: (details) {
                                    if (details.delta.dx > 4) {
                                      swipe = 'right';
                                    } else if (details.delta.dx < 4) {
                                      swipe = 'left';
                                    }
                                  }, onPanEnd: (details) {
                                    if (swipe == 'right' || swipe == 'left') {
                                      _incrementSwipes();
                                    }
                                  }))
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
                                builder: (context) =>
                                    ShopScreen(onDuckUpdated: (duffyUpt) {
                                      if (duffyUpt != null) {
                                        setState(() {
                                          duffy = duffyUpt;
                                        });
                                      }
                                    })));
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

  @override
  void dispose() {
    _mallardsNotifier.dispose();
    _duckinessNotifier.dispose();
    super.dispose();
  }
}

