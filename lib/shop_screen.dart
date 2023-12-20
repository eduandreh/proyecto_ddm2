import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/DuffyAccessory.dart';
import 'package:proyecto_ddm2/Shop.dart';
import 'Duffy.dart';
import 'firebase_manager.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreen();
}

class _ShopScreen extends State<ShopScreen> {

  List<Shop> shopObjects = [];
  List<DuffyAccessory> duffyObjects = [];
  List<dynamic> duffyObjectsDynamic = [];

  FirebaseManager fManager = FirebaseManager();

  Duffy? _duffy;

  List<String> weatherIcons = [
    'assets/weather/1rain_icon.png',
    'assets/weather/2hot_icon.png',
    'assets/weather/3snow_icon.png',
    'assets/weather/4wind_icon.png',
    'assets/weather/5tornado_icon.png',
    'assets/weather/6sun_icon.png',
  ];

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    shopObjects = await fManager.getShop();
    _duffy = await fManager.getDuck();
    duffyObjectsDynamic = _duffy?.accessories;
    duffyObjects = convertDynamicList(duffyObjectsDynamic);
    sortObjects();
    setState(() {});
  }

  List<DuffyAccessory> convertDynamicList(List<dynamic> dynamicList) {
    List<DuffyAccessory> result = dynamicList.map((dynamic item) {
      return DuffyAccessory(
        name: item['name'] ?? '',
        sold: item['sold'] ?? '',
        gotten: item['gotten'] ?? '',
      );
    }).toList();

    return result;
  }

  void sortObjects() {
    duffyObjects.sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> updateAccessoryImage(index) async {

    List<String> accessoriesURL = await fManager.getImagesURL("/ducks/${_duffy?.color}/");
    var accessoryImage = accessoriesURL[index];

    await fManager.updateAccessoryImage(accessoryImage);

  }

  Future <void> updateSoldObject(index) async {
    //change preSold object to false
    for (var object in duffyObjects) {
      if (object.sold) {
        await fManager.updateSoldBool(false, object.name, object.gotten);
      }
    }

    //change bought object: sold & gotten to true
    await fManager.updateSoldBool(true, duffyObjects[index].name, duffyObjects[index].gotten);

    //update Mallards
    await fManager.updateMallards(-shopObjects[index].price);
    await updateAccessoryImage(index);
  }

  void buyAccessory(index) async {

    var isLocked = 0;

    //verify locked accessory (ball) by looking all 4 objects
    for(var object in duffyObjects) {
      if(object.gotten) {
        isLocked++;
      }
    }

    if (shopObjects[index].price <= _duffy!.coins) {
      //verification of locked object
      if (duffyObjects[index].name == "5ball") {
        if(isLocked >= 4) {  //we need to know if the other 4 objects are gotten
          await updateSoldObject(index);
        }
      } else {  //not trying to buy the locked object
        await updateSoldObject(index);
      }

      print("finalllllll!!!!!!!!");

    } else {
      print("Not enough money!");
    }

    setState(() {});

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
                  _duffy == null ? "000" : _duffy!.coins.toString(),
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
              Visibility(
                visible: shopObjects.isEmpty,
                child: Image(
                  image: Image.asset(  //placeholder
                      "assets/placeholders/duck_shop_placeHolder.png")
                      .image,
                  width: 400,
                ),
              ),
              Visibility(
                visible: shopObjects.isNotEmpty,
                child: Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                              image: shopObjects.isNotEmpty
                                  ? NetworkImage(shopObjects[index].image)
                                  : const NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/shop_accessories%2F1umbrella.png?alt=media&token=57da99d1-bbce-43f4-a435-3b1b5ac4dd9e"),
                              width: 101,
                            ),
                            const SizedBox(width: 64),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    Image(
                                      //weather icon
                                      image: Image.asset(weatherIcons[index])
                                          .image,
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
                                    Text(
                                      shopObjects.isNotEmpty
                                          ? '${shopObjects[index].price}'
                                          : '000',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                FilledButton(
                                    onPressed: () => duffyObjects[index].sold ? '' :  buyAccessory(index),
                                    style: ButtonStyle(
                                      backgroundColor: duffyObjects[index].sold ? const MaterialStatePropertyAll(Colors.grey) : const MaterialStatePropertyAll(Color(0xff236A26)),
                                    ),
                                    child: Row(children: [
                                      const Text("Comprar"),
                                      const SizedBox(width: 4),
                                      Image(
                                        //shopping cart icon
                                        image: Image.asset(
                                                "assets/icons/shopping_cart.png")
                                            .image,
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
              ),
            ])));
  }
}
