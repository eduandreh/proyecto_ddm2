import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_ddm2/DuffyAccessory.dart';
import 'package:proyecto_ddm2/firebase_manager.dart';
import 'package:proyecto_ddm2/main_duck_screen.dart';

Future<void> addDuffy(String name, String location, String outfit, int mallards, double duckiness, int life, List<DuffyAccessory> accessories, String color) async {
  var userID = FirebaseAuth.instance.currentUser!.uid;
  var duffyRef = FirebaseFirestore.instance.collection("users").doc(userID);

 var accessoriesMap = accessories.map((accessory) => accessory.toFirestore()).toList();
  return duffyRef.set({
    'Name': name,
    'Location': location,
    'Outfit': outfit,
    'Mallards': mallards,
    'Duckiness': duckiness,
    'Life': life,
    'Accessories': accessoriesMap,  
    'Last_connection': DateTime.now(),
    'Created_at': DateTime.now(),
    'Color': color,
  });
}



class DuckCreator extends StatefulWidget {
  const DuckCreator({super.key});

  @override
  State<DuckCreator> createState() => _DuckCreatorState();
}

enum DuckColor { yellow, purple, blue, green }

String getImageUrl(DuckColor outfit) {
  switch (outfit) {
    case DuckColor.yellow:
      return 'https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/plainDucks%2FduckYellow.png?alt=media&token=37019781-6f79-4086-9e8b-1dc3893bf8e0';
    case DuckColor.purple:
      return 'https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/plainDucks%2FduckPurple.png?alt=media&token=c73e35dd-26f1-4dbc-bdba-f3718b69008b';
    case DuckColor.blue:
      return 'https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/plainDucks%2FduckBlue.png?alt=media&token=c37abfa9-1d52-4ee9-9df8-c05532a97525';
    case DuckColor.green:
      return 'https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/plainDucks%2FduckGreen.png?alt=media&token=46d04ead-a6bd-4c4f-b6b1-d396a3de07a7';
    default:
      return 'https://firebasestorage.googleapis.com/v0/b/duffy-264e6.appspot.com/o/plainDucks%2FduckYellow.png?alt=media&token=37019781-6f79-4086-9e8b-1dc3893bf8e0';
  }
}

const List<String> cities = <String>['Alaska', 'Barcelona', 'El Cairo', 'Los Angeles', 'Paris'];

class _DuckCreatorState extends State<DuckCreator> {
  TextEditingController _duffyNameController = TextEditingController();

  String userId = FirebaseAuth.instance.currentUser!.uid;

  DuckColor _selectedColor = DuckColor.yellow; 
  String dropdownLocation = cities.first;

  void _setColor(DuckColor outfit) {
    setState(() {
      _selectedColor = outfit;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 60),
            const Text(
              'Adoptemos!',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Text(
              'cómo será tu Duffy?',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
              Image.network(
            getImageUrl(_selectedColor),
            height: 200,
            width: 200,        
          ),
         Container( 
          
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FilledButton(onPressed: () {
            _setColor(DuckColor.yellow);
             },
          style: FilledButton.styleFrom(
            shape: CircleBorder(
              
            ),
            
            backgroundColor: Color.fromRGBO(252, 243, 38, 1),
          ), child: Container()),

          FilledButton(onPressed: () {
            _setColor(DuckColor.purple);
             },
          style: FilledButton.styleFrom(
            shape: CircleBorder(
            ),
            backgroundColor: Color.fromRGBO(165, 130, 253, 1),
          ), child: Container()),

          FilledButton(onPressed: () {
            _setColor(DuckColor.blue);
             },
          style: FilledButton.styleFrom(
            shape: CircleBorder(
            ),
            backgroundColor: Color.fromRGBO(47, 187, 187, 1),
          ), child: Container()),

          FilledButton(onPressed: () {
            _setColor(DuckColor.green);
             },
          style: FilledButton.styleFrom(
            shape: CircleBorder(
            ),
            backgroundColor: Color.fromRGBO(30, 176, 89, 1),
          ), child: Container()),

          ]
        ),
         ),
            const SizedBox(height: 20),
            TextField(
              controller: _duffyNameController,
              decoration: const InputDecoration(
                hintText: 'Nombre de tu Duffy',
                suffixIcon: Icon(Icons.pets),
                
              ),
            ),
            const SizedBox(height: 20),

    DropdownButton<String>(
      value: dropdownLocation,
      elevation: 16,
      
      onChanged: (String? value) {
        setState(() {
          dropdownLocation = value!;
        });
      },
      isExpanded: true,
      items: cities.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList()
    ),

    //     DropdownMenu<String>(
    //   initialSelection: cities.first,
    //   onSelected: (String? value) {
    //     setState(() {
    //       dropdownValue = value!;
    //     });
    //   },
    //   dropdownMenuEntries: cities.map<DropdownMenuEntry<String>>((String value) {
    //     return DropdownMenuEntry<String>(value: value, label: value);
    //   }).toList(),
    // ),
            const SizedBox(height: 40),
            ElevatedButton(
               onPressed: ()  {
                  _createDuffy();

               },
               style: ElevatedButton.styleFrom(
                 primary: const Color.fromRGBO(221, 138, 41, 1),
                 onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                   
               ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                //width: MediaQuery.of(context).size.width * 0.5,
                child: const Text(
                  'Entrar >',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

Future<void> _createDuffy() async {
  var name = _duffyNameController.text;
  var location = dropdownLocation;
  var outfit = getImageUrl(_selectedColor); 
  var color = _selectedColor.toString().split('.').last;
  

  if (name.isNotEmpty && location.isNotEmpty) {
    try {
      FirebaseManager fManager = FirebaseManager();
      List<DuffyAccessory> defaultAccessories = await fManager.getDefaultAccessories();


      await addDuffy(name, location, outfit, 0, 100.0, 0, defaultAccessories, color);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainDuck()));

    } catch (error) {
      
      print('Error al crear o actualizar Duffy: $error');
    }
  } 
}
}