import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:travel_app/modules/classes.dart';
import 'package:travel_app/modules/database.dart';
import 'package:travel_app/widgets/image.dart';
import 'package:provider/provider.dart';

class SavePlacePage extends StatefulWidget {
  static const routeName = "savePlace";
  final BuildContext LastContext;
  final double Lat;
  final double Long;
  const SavePlacePage(
      {super.key,
      required this.LastContext,
      required this.Lat,
      required this.Long});

  @override
  State<SavePlacePage> createState() => _SavePlacePageState();
}

class _SavePlacePageState extends State<SavePlacePage> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudedeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DataBaseHelper _dataBaseHelper = DataBaseHelper();
  static User user = FirebaseAuth.instance.currentUser!;

  File? savedImage;
  void _imageController(File image) {
    savedImage = image;
  }

  void savePlace() {
    if (_latitudeController.text.isNotEmpty &&
        _longitudedeController.text.isNotEmpty &&
        _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _imageController != null) {
      try {
        Provider.of<PlaceNotifier>(widget.LastContext, listen: false).addPlace(
            user!.uid,
            _latitudeController.text.trim(),
            _longitudedeController.text.trim(),
            _titleController.text.trim(),
            _descriptionController.text.trim(),
            savedImage!);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("New travel place was saved!")));

        Navigator.pop(context);
      } on DatabaseException catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                  content:
                      Text('Error to save the place, please check it again'));
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(content: Text('All fields are required'));
          });
    }
  }

  @override
  void initState() {
    _latitudeController.text = widget.Lat.toString();
    _longitudedeController.text = widget.Long.toString();
    super.initState();
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudedeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save new place'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const Text(
                'Saving a new travel location',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Latitude',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: TextFormField(
                      controller: _latitudeController,
                      readOnly: true,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Longitude',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: TextFormField(
                      controller: _longitudedeController,
                      readOnly: true,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Title',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: TextFormField(
                      maxLength: 60,
                      controller: _titleController,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: TextFormField(
                      maxLength: 1024,
                      maxLines: 4,
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ImageSave(_imageController),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: MaterialButton(
                        onPressed: savePlace,
                        color: Colors.deepPurple[200],
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
