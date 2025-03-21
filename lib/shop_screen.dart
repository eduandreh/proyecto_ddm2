import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/DuffyAccessory.dart';
import 'package:proyecto_ddm2/Shop.dart';
import 'Duffy.dart';
import 'firebase_manager.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key, required this.onDuckUpdated});

  final Function(Duffy? duffy) onDuckUpdated;

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
    //first we get the image of the duck with the accessory selected and the color of the duck
    List<String> accessoriesURL =
        await fManager.getImagesURL("/ducks/${_duffy?.color}/");
    var accessoryImage = accessoriesURL[index];
    await fManager.updateAccessoryImage(accessoryImage);
  }

  Future<void> updateSoldObject(index) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comprando...'),
      ),
    );

    //change preSold object to false
    for (var object in duffyObjects) {
      if (object.sold) {
        await fManager.updateSoldBool(false, object.name, object.gotten);
      }
    }

    //change bought object: sold & gotten to true
    await fManager.updateSoldBool(
        true, duffyObjects[index].name, duffyObjects[index].gotten);

    //update Mallards
    await fManager.incrementDuffyField("Mallards", -shopObjects[index].price);
    await updateAccessoryImage(index);
  }

  bool isBallLocked() {
    var isLocked = 0;

    //verify locked accessory (ball) by looking all objects
    for (var object in duffyObjects) {
      if (object.gotten) {
        isLocked++;
      }
    }

    return isLocked >= 4;
  }

  void buyAccessory(index) async {
    //verification of locked object
    if (duffyObjects[index].name == "5ball") {
      if (isBallLocked()) {
        //we need to know if the other 4 objects are gotten
        if (shopObjects[index].price <= _duffy!.mallards) {
          //verify if enough mallards
          await updateSoldObject(index);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No tienes suficientes Mallards!'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se han comprado los previos objetos.'),
          ),
        );
      }
    } else {
      //not trying to buy the locked object
      if (shopObjects[index].price <= _duffy!.mallards) {
        //verify if enough mallards
        await updateSoldObject(index);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No tienes suficientes Mallards!'),
          ),
        );
      }
    }

    getInfo(); //update shop with new bought object
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: BackButton(
              onPressed: () {
                widget.onDuckUpdated(_duffy);
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
                  _duffy == null ? "000" : _duffy!.mallards.toString(),
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
                  image: Image.asset(//placeholder
                      "assets/placeholders/duck_shop_placeHolder.png").image,
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
                                  : Image.asset(//placeholder
                                          "assets/placeholders/duck_shop_placeHolder.png")
                                      .image,
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
                                    const SizedBox(width: 15),
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
                                    onPressed: () => duffyObjects[index].sold
                                        ? ''
                                        : buyAccessory(index),
                                    style: ButtonStyle(
                                      backgroundColor: duffyObjects[index].sold
                                          ? const MaterialStatePropertyAll(
                                              Colors.grey)
                                          : const MaterialStatePropertyAll(
                                              Color(0xff236A26)),
                                    ),
                                    child: Row(children: [
                                      Text(duffyObjects[index].sold
                                          ? "Usando"
                                          : duffyObjects[index].gotten
                                              ? "Recomprar"
                                              : "Comprar"),
                                      const SizedBox(width: 4),
                                      Image(
                                        //shopping cart icon
                                        image: isBallLocked() || index != 4
                                            ? Image.asset(
                                                    "assets/icons/shopping_cart.png")
                                                .image
                                            : Image.asset(
                                                    "assets/icons/lock.png")
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
            ]))
    ));
  }
}
