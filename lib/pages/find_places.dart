import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:travel_app/pages/save_place.dart';

import '../modules/classes.dart';
import '../modules/database.dart';

class FindFriends extends StatefulWidget {
  const FindFriends({Key? key}) : super(key: key);

  @override
  _FindFriendsState createState() => _FindFriendsState();
}

const kGoogleApiKey = 'AIzaSyCobGBgzr8Gqc5d3992In_jW2wd0m_r540';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _FindFriendsState extends State<FindFriends> {
  late CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static User user = FirebaseAuth.instance.currentUser!;

  List<Map> _list = [];
  DataBaseHelper database = DataBaseHelper();
  Set<Marker> _markers = {};
  Set<Marker> markersList = {};
  late String Lat = "";
  late String Long = "";
  Completer<GoogleMapController> _googleMapController = Completer();
  final Mode _mode = Mode.overlay;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('Location permission are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission are permanently denied, we cannot request');
    }
    return await Geolocator.getCurrentPosition();
  }

  final List<dynamic> _data = [];

  Future<void> getData() async {
    await Provider.of<PlaceNotifier>(context, listen: false)
        .fetchPlaces(user!.uid);
    final items = Provider.of<PlaceNotifier>(context, listen: false).items;
    print(items);
    for (var element in items) {
      _data.add({
        "id": element.id,
        "name": element.title,
        "description": element.description,
        "position": LatLng(
            double.parse(element.latitude), double.parse(element.longitude)),
        "marker": 'assets/markers/marker-7.png',
        "image": element.image.path,
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    getData();
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
            mapType: MapType.normal,
            myLocationEnabled: true,
            onLongPress: (locs) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ListenableProvider<PlaceNotifier>(
                  create: (_) => PlaceNotifier(),
                  builder: (context, child) {
                    return SavePlacePage(
                        LastContext: context,
                        Lat: locs.latitude,
                        Long: locs.longitude);
                  },
                );
              })).then((value) {
                setState(() {
                  getData();
                });
              });
            },
            onMapCreated: (GoogleMapController controller) {
              _googleMapController.complete(controller);
              controller.setMapStyle(MapStyle().aubergine);
            },
          ),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
                  MaterialButton(
                 onPressed: _handlePressButton,
                 color: Colors.deepPurple[200],

                 child:  Text("Search Places"))
           ],
         ),
         Positioned(

           left: 20,
           right: 20,
           top: 70,

           child: Container(
               width: MediaQuery.of(context).size.height,
               height: 100,
               decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(20)),
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount: _data.length,
                 itemBuilder: (context, index) {
                   return GestureDetector(
                     onTap: () async {
                       final GoogleMapController controller =
                       await _googleMapController.future;
                       controller.moveCamera(
                           CameraUpdate.newLatLng(_data[index]["position"]));
                       setState(() {});
                     },
                     child: Container(
                       width: 100,
                       height: 100,
                       margin: const EdgeInsets.only(right: 10),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           ClipRRect(
                             borderRadius: BorderRadius.circular(100),
                             child: Image.file(
                               File(
                                 _data[index]['image'],
                               ),
                               width: 60,
                               height: 60,
                             ),
                           ),
                           const SizedBox(
                             height: 10,
                           ),
                           Text(
                             _data[index]["name"],
                             style: const TextStyle(
                                 color: Colors.black,
                                 fontWeight: FontWeight.w600),
                           )
                         ],
                       ),
                     ),
                   );
                 },
               )),
         ) ,
        ],
      ),
      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.deepPurple[200],
        onPressed: () async {
          _getCurrentLocation().then((value) async {
            _markers.add(Marker(
                markerId: const MarkerId('current_location'),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: const InfoWindow(title: 'Your current location')));
            CameraPosition cameraPosition = CameraPosition(
                target: LatLng(value.latitude, value.longitude), zoom: 14.4746);
            final GoogleMapController controller =
                await _googleMapController.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        child: const Icon(Icons.location_on),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  createMarkers(BuildContext context) {
    Marker marker;

    _data.forEach((contact) async {
      marker = Marker(
        markerId: MarkerId(contact['id']),
        position: contact['position'],
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: contact['name'],
          snippet: contact['description'],
        ),
      );

      setState(() {
        _markers.add(marker);
      });
    });
  }

  Future<BitmapDescriptor> _getAssetIcon(
      BuildContext context, String icon) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config =
        createLocalImageConfiguration(context, size: const Size(5, 5));

    AssetImage(icon)
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData? bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
          BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    }));

    return await bitmapIcon.future;
  }

  void onError(PlacesAutocompleteResponse response) {
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
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "pk"),
          Component(Component.country, "usa")
        ]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    final GoogleMapController controller = await _googleMapController.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.4746));
    setState(() {});
  }
}
