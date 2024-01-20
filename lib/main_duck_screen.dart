import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/migration_screen.dart';
import 'package:proyecto_ddm2/settings_screen.dart';
import 'package:proyecto_ddm2/shop_screen.dart';
import 'package:proyecto_ddm2/tutorial_screen.dart';
import 'package:proyecto_ddm2/weather_api_manager.dart';
import 'Duffy.dart';
import 'firebase_manager.dart';

class MainDuck extends StatefulWidget {
  const MainDuck({super.key});

  @override
  State<MainDuck> createState() => _MainDuck();
}

class _MainDuck extends State<MainDuck> {
  int _swipesMallards = 0;
  int _swipesDuckiness = 0;

  FirebaseManager fManager = FirebaseManager();
  String swipe = '';

  late Duffy? duffy;
  late String? weather;
  String _backgroundImage = '';

  late ValueNotifier<int?> _mallardsNotifier;
  late ValueNotifier<double?> _duckinessNotifier;

  @override
  void initState() {
    super.initState();
//    saveAppOpenTime();
    _mallardsNotifier = ValueNotifier<int?>(0);
    _duckinessNotifier = ValueNotifier<double?>(100.0);
  }

  Future<Duffy> getDuffy() async {
    duffy = await fManager.getDuck();
    weather = await getCurrentWeather(duffy!.location);
    await updateDuckiness(duffy!, weather!);
    await lifeCheck();
    duffy = await fManager.getDuck();
    _mallardsNotifier.value = duffy!.mallards;
    _duckinessNotifier.value = duffy!.duckiness;
    _backgroundImage = await fManager.getSpecificFile("/backgrounds/", duffy!.location);
    return duffy!;
  }

  void _incrementSwipes() {
    _swipesMallards = _swipesMallards + 1;
    _swipesDuckiness = _swipesDuckiness + 1;

    _mallardsNotifier.value = _mallardsNotifier.value! + 1;
    if (_swipesMallards == 10) {
      fManager.incrementDuffyField("Mallards", 10);
      _swipesMallards = 0;
    }

    if (_swipesDuckiness == 10 && _duckinessNotifier.value! < 100) {
      fManager.incrementDuffyField("Duckiness", 0.5);
      _duckinessNotifier.value = _duckinessNotifier.value! + 0.5;
      _swipesDuckiness = 0;
    }
  }

  Future<void> lifeCheck() async {
    Duration difference = DateTime.now()
        .difference(DateTime.parse(duffy!.created_at.toDate().toString()));

    int days = difference.inDays;
    await fManager.incrementDuffyField("Life", days);
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
    duffy = await fManager.getDuck();
    if (duffy.duckiness == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MigrationScreen()));
    }
  }

  void updateMallards() {
    fManager.incrementDuffyField("Mallards", _swipesMallards);
    _swipesMallards = 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDuffy(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null && _backgroundImage.isNotEmpty) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.black87,
                  centerTitle: true,
                  bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(0), child: SizedBox()),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()));
                    },
                    icon: const Icon(Icons.settings, color: Color(0xffDD8A29)),
                  ),
                  leadingWidth: 50,
                  title: Column(
                    children: <Widget>[
                      Text(
                        duffy!.location,
                        style: const TextStyle(
                            fontSize: 18, color: Color(0xffdaa15e)),
                      ),
                      const SizedBox(height: 5),
                      Image.asset(
                        weather!,
                        color: Colors.orange,
                        height: 25,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Mallards"),
                                  content: const Text(
                                      "Los Mallards son monedas que puedes intercambiar por accesorios. ¡Consigue más Mallards acariciando a tu Duffy!"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cerrar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Transform.rotate(
                            angle: 3.14159 / 2,
                            child: const Text(
                              'M',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffDD8A29),
                              ),
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
                                color: Color(0xffdaa15e),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                  ]),
              body: Center(
                  child: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(_backgroundImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //weather icon
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 20),
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
                                            value: duckiness == 0.0 ||
                                                    duckiness == null
                                                ? 0.0
                                                : duckiness / 100,
                                            backgroundColor: Colors.grey[300],
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Color(0xffDD8A29)),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30)),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Duckiness"),
                                              content: const Text(
                                                  "Duckiness representa la felicidad de tu Duffy.\nPara mantener a tu Duffy feliz y evitar que emigre, es crucial equiparlo con el accesorio adecuado y acariciarlo regularmente. \n¡Elige con cuidado y asegúrate de que tu Duffy se sienta siempre contento!"),
                                              actions: [
                                                TextButton(
                                                  child: Text("Cerrar"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        "DUCKINESS",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  Text(duffy!.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32,
                                      )),
                                  const SizedBox(width: 50),
                                  GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Días de Vida de tu Duffy"),
                                              content: const Text(
                                                  "¡Manten contento a tu Duffy para que viva más!"),
                                              actions: [
                                                TextButton(
                                                  child: Text("Cerrar"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Text(
                                              "D",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Color(0xff9C4615)),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                                duffy!.life != 0
                                                    ? duffy!.life.toString()
                                                    : "0",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 28,
                                                )),
                                          ]))
                                ],
                              ),
                              const SizedBox(height: 20),

                              Stack(
                                children: <Widget>[
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
                                      child: GestureDetector(
                                          onPanUpdate: (details) {
                                        if (details.delta.dx > 4) {
                                          swipe = 'right';
                                        } else if (details.delta.dx < 4) {
                                          swipe = 'left';
                                        }
                                      }, onPanEnd: (details) {
                                        if (swipe == 'right' ||
                                            swipe == 'left') {
                                          _incrementSwipes();
                                        }
                                      }))
                                ],
                              ),
                            ])
                      ])
                ],
              )),
              bottomNavigationBar: BottomAppBar(
                color: Colors.black87,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      iconSize: 30,
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TutorialScreen()));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_business),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      iconSize: 30,
                      onPressed: () async {
                        updateMallards();
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
