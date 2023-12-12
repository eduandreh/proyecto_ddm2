import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  const Shop({super.key, required this.title});

  final String title;

  @override
  State<Shop> createState() => _Shop();
}

class _Shop extends State<Shop> {

  int _counter = 0;

  List<String> accessoriesImages = [
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessories%2Fumbrella_shop.png?alt=media&token=6eeff6b4-2c6d-4bdf-a8e9-35507390c3fe",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessories%2FsunGlasses_shop.png?alt=media&token=e758ee82-652c-4ac6-b348-cbf33461a398",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessories%2Fscarf_shop.png?alt=media&token=e9988a16-d556-4451-8d77-0cfec965977d",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessories%2Fhat_shop.png?alt=media&token=4d3c03c4-d55d-4497-8b1b-1fba5ce116e4",
    "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessories%2Fball_shop.png?alt=media&token=a7ee0024-0d68-4197-be8d-8fd458072a8d",
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: BackButton(
              onPressed: _incrementCounter,
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
                const Text(
                  "359",
                  style: TextStyle(
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
                            mainAxisSpacing: 2.0,
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
                                        const Image(
                                          image: NetworkImage(
                                              "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/icons%2Fdrizzle.png?alt=media&token=c14005fc-b51b-49fc-8575-1efc5f692467"),
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
                                          Image(
                                            image: NetworkImage(
                                                "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/icons%2Fshopping_cart.png?alt=media&token=9e736d31-575c-4ab7-bc7d-fe9ed3c9d2d7"),
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
