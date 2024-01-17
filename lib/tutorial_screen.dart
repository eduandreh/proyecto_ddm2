import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreen();
}

class _TutorialScreen extends State<TutorialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black,
            )),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("¿Cómo jugar?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 320,
                    child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("Duckiness",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                              const SizedBox(width: 12),
                              SizedBox(
                                  width: 120,
                                  height: 15,
                                  child:
                                  LinearProgressIndicator(
                                    value: 0.85,
                                    backgroundColor: Colors.grey[300],
                                    valueColor:
                                    const AlwaysStoppedAnimation<
                                        Color>(Color(0xffDD8A29)),
                                    borderRadius:
                                    const BorderRadius.all(
                                        Radius.circular(30)),
                                  )),
                              const SizedBox(width: 12),
                              Image(
                                image: Image.asset("assets/weather/6sun_icon.png").image,
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Duckiness representa la felicidad de tu Duffy. Para mantener a tu Duffy feliz y evitar que emigre, es crucial equiparlo con el accesorio adecuado y acariciarlo regularmente. ¡Compra el accesorio que mejor vaya con el clima de tu ciudad!",
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text("Mallards",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                              const SizedBox(width: 6),
                              Transform.rotate(
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
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                              "Los Mallards son monedas que puedes intercambiar por accesorios. ¡Consigue más Mallards acariciando a tu Duffy!",
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Text("Life",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                              SizedBox(width: 6),
                              Text(
                                  'D',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffDD8A29),
                                  ),
                                ),

                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                              "Muestra los días que llevas con tu Duffy. ¡Manten contento a tu Duffy comprando los accesorios correctos y acariciándolo para que viva más!",
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Text("Shop",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                              SizedBox(width: 6),
                              Icon(
                                  Icons.add_business,
                                  color: Color(0xffDD8A29),
                              )

                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                              "Los accesorios de la tienda sirven para proteger a tu Duffy del clima de la ciudad. Si quieres despreocuparte por que accesorio comprar, apuesta por la bola, pero es necesario haber comprado los otros objetos antes. ¡Vigila, cuando compras un objeto pierdes el anterior!",
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ],
                      )
                  )
                ])));
  }
}
