import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:travel_app/model/map_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class FindFriends extends StatefulWidget {
  const FindFriends({ Key? key }) : super(key: key);

  @override
  _FindFriendsState createState() => _FindFriendsState();
}

const kGoogleApiKey = 'AIzaSyCobGBgzr8Gqc5d3992In_jW2wd0m_r540';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _FindFriendsState extends State<FindFriends> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> _markers = {};
  Set<Marker> markersList = {};
  late GoogleMapController _googleMapController;
  final Mode _mode = Mode.overlay;

  final List<dynamic> _contacts = [
    {
      "name": "Me",
      "position": const LatLng(37.42796133580664, -122.085749655962),
      "marker": 'assets/markers/marker-1.png',
      "image": 'assets/images/avatar-1.png',
    },
    {
      "name": "Samantha",
      "position": const LatLng(37.42484642575639, -122.08309359848501),
      "marker": 'assets/markers/marker-2.png',
      "image": 'assets/images/avatar-2.png',
    },
    {
      "name": "Malte",
      "position": const LatLng(37.42381625902441, -122.0928531512618),
      "marker": 'assets/markers/marker-3.png',
      "image": 'assets/images/avatar-3.png',
    },
    {
      "name": "Julia",
      "position": const LatLng(37.41994095849639, -122.08159055560827),
      "marker": 'assets/markers/marker-4.png',
      "image": 'assets/images/avatar-4.png',
    },
    {
      "name": "Tim",
      "position": const LatLng(37.413175077529935, -122.10101041942836),
      "marker": 'assets/markers/marker-5.png',
      "image": 'assets/images/avatar-5.png',
    },
    {
      "name": "Sara",
      "position": const LatLng(37.419013242401576, -122.11134664714336),
      "marker": 'assets/markers/marker-6.png',
      "image": 'assets/images/avatar-6.png',
    },
    {
      "name": "Ronaldo",
      "position": const LatLng(37.40260962243491, -122.0976958796382),
      "marker": 'assets/markers/marker-7.png',
      "image": 'assets/images/avatar-7.png',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    createMarkers(context);

    return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              markers: _markers,
              mapType: MapType.hybrid,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
                controller.setMapStyle(MapStyle().aubergine);
              },
            ),
            ElevatedButton(onPressed: _handlePressButton, child: const Text("Search Places")),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _contacts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _googleMapController.moveCamera(CameraUpdate.newLatLng(_contacts[index]["position"]));
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(_contacts[index]['image'], width: 60,),
                              const SizedBox(height: 10,),
                              Text(_contacts[index]["name"], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),)
                            ],
                          ),
                        ),
                      );
                    },
                  )
              ),
            )
          ],
        )
    );
  }

  createMarkers(BuildContext context) {
    Marker marker;

    _contacts.forEach((contact) async {
      marker = Marker(
        markerId: MarkerId(contact['name']),
        position: contact['position'],
        icon: await _getAssetIcon(context, contact['marker']).then((value) => value),
        infoWindow: InfoWindow(
          title: contact['name'],
          snippet: 'Street 6 . 2min ago',
        ),
      );

      setState(() {
        _markers.add(marker);
      });
    });
  }

  Future<BitmapDescriptor> _getAssetIcon(BuildContext context, String icon) async {
    final Completer<BitmapDescriptor> bitmapIcon = Completer<BitmapDescriptor>();
    final ImageConfiguration config = createLocalImageConfiguration(context, size: const Size(5, 5));

    AssetImage(icon)
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData? bytes = await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    })
    );

    return await bitmapIcon.future;
  }

  void onError(PlacesAutocompleteResponse response){

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country,"pk"),Component(Component.country,"usa")]);


    displayPrediction(p!,homeScaffoldKey.currentState);
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {

    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(markerId: const MarkerId("0"),position: LatLng(lat, lng),infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.4746));

  }

}



