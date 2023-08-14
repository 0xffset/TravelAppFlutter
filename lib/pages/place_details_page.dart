import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/modules/classes.dart';
import 'package:intl/intl.dart';

class PlaceDetailPage extends StatefulWidget {
  BuildContext lastContext;
  String id = "";
  PlaceDetailPage({super.key, required this.lastContext, required this.id});

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  static User user = FirebaseAuth.instance.currentUser!;
  final df =  DateFormat('dd-MM-yyyy hh:mm a');
  Place? _image;

  Future fetchDetail() async {
    final image =
        await Provider.of<PlaceNotifier>(widget.lastContext, listen: false)
            .fetchPlaceById(widget.id);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    fetchDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TravelApp - ${_image!.title}'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: SingleChildScrollView(
        child: _image != null
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    height: 400,
                    width: double.infinity,
                    child: Image.file(
                      _image!.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text("Title",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.0)),
                  Text(
                    _image!.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Description",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0)),
                  Text(
                    _image!.description,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Latitude",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0)),
                  Text(
                    _image!.latitude,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Longitude",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0)),
                  Text(
                    _image!.longitude,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Datetime",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0)),
                  Text(
                    'The place was recorded at ${df.format(DateTime.parse(_image!.time))} ',
                    style: const TextStyle(fontSize: 15.0),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
