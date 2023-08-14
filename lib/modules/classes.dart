import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'database.dart';

var uuid = const Uuid();

class Place {
  late final String id;
  late final String uid;
  late final String title;
  late final String latitude;
  late final String longitude;
  late final String description;
  late final File image;
  late final time;

  Place(
      {required this.image,
      required this.title,
      required this.description,
      required this.id,
      required this.time,
      required this.uid,
      required this.latitude,
      required this.longitude});
}

class PlaceNotifier with ChangeNotifier {
  List<Place> _items = [];
  List<Place> get items {
    return [..._items];
  }

  void deleteMomentFromList(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void addItemToList(int index, Place place) {
    _items.insert(index, place);
    notifyListeners();
  }

  Future<int> deletePlaceById(String id) async {
    var res = await DataBaseHelper.remove_moment(id);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    return res;
  }

  Future<void> cleanDatabase() async {
    _items.clear();
    notifyListeners();
    await DataBaseHelper.clean_database();
  }

  Future<void> addPlace(String uid, String latitude, String longitude,
      String title, String description, File image) async {
    final newImage = Place(
        uid: uid,
        latitude: latitude,
        longitude: longitude,
        image: image,
        title: title,
        description: description,
        id: uuid.v1(),
        time: DateTime.now().toString());
    _items.add(newImage);
    notifyListeners();
    DataBaseHelper.insert('places', {
      'id': newImage.id,
      'uid': newImage.uid,
      'title': newImage.title,
      'latitude': newImage.latitude,
      'longitude': newImage.longitude,
      'description': newImage.description,
      'time': newImage.time,
      'image': newImage.image.path,
    });
  }

  Place findImage(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<Place> fetchPlaceById(String id) async {
    final list = await DataBaseHelper.getDataById('places',  id);
    _items = list
        .map((e) => Place(
      image: File(e['image']),
      title: e['title'],
      latitude: e['latitude'],
      longitude: e['longitude'],
      description: e['description'],
      time: e['time'],
      id: e['id'],
      uid: e['uid'],
    ))
        .toList();
    return _items.first;
    notifyListeners();
  }

  Future<void> fetchPlaces(String uid) async {
    final list = await DataBaseHelper.getData('places',  uid);
    _items = list
        .map((e) => Place(
              image: File(e['image']),
              title: e['title'],
              latitude: e['latitude'],
              longitude: e['longitude'],
              description: e['description'],
              time: e['time'],
              id: e['id'],
              uid: e['uid'],
            ))
        .toList();
    notifyListeners();
  }
}
