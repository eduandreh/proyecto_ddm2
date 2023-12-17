import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _Shop();
}

class _Shop extends State<Shop> {

  int _counter = 950;

  List<String> accessoriesImages = [
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessoriesV2%2Fumbrella.png?alt=media&token=4d5c16ee-b01f-4172-9ad3-b10f36a59bbb",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessoriesV2%2Fsunglasses2.png?alt=media&token=117759c0-8fc8-4896-82fa-bdcaf5e63d95",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessoriesV2%2Fscarf.png?alt=media&token=9350b355-9090-4d6d-baed-578feedf90b4",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessoriesV2%2Fhat.png?alt=media&token=fcc3520d-a72a-464d-85e6-aa4c280f558c",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessoriesV2%2Fball.png?alt=media&token=08932950-6a1a-4936-a4da-77e04b930cdc",
  ];

  List<String> weatherIcons = [
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/icons%2Frain_icon.png?alt=media&token=4a539845-c931-42b5-826a-70c11b70ffb6",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/icons%2Fhot_icon.png?alt=media&token=14b61246-9db1-46dc-892b-5f66e689252f",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/icons%2Fsnow_icon.png?alt=media&token=d81c247a-13e8-4912-8025-272839f9dfb5",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/icons%2Fwind_icon.png?alt=media&token=ebd1728c-c54e-4272-9682-e5e97c02267d",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/icons%2Ftornado_icon.png?alt=media&token=1a16ef41-cf25-493b-96ac-fcd0a5d945f6",
  ];

  void _incrementCounter() {
    setState(() {
      _counter = _counter - 150;
    });
  }

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
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                  "$_counter",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Compremos!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      )),
                  Text("que llevará tu Duffy?",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      )),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 1.0,
                      childAspectRatio: 4),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: NetworkImage(accessoriesImages[index]),
                            width: 101,
                          ),
                          const SizedBox(width: 64),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Image(  //weather icon
                                    image: NetworkImage(weatherIcons[index]),
                                    width: 24,
                                  ),
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
                                    "150",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              FilledButton(
                                  onPressed: _incrementCounter,
                                  style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color(0xff236A26)),
                                  ),
                                  child: const Row(children: [
                                    Text("Comprar"),
                                    SizedBox(width: 4),
                                    Image(  //shopping cart icon
                                      image: NetworkImage(
                                          "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/icons%2Fshopping_cart.png?alt=media&token=9e736d31-575c-4ab7-bc7d-fe9ed3c9d2d7"),
                                      width: 24,
                                    ),
                                  ]))
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ])));
  }
}
