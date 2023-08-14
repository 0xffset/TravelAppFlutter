import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/modules/classes.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_app/pages/place_details_page.dart';

class PlacesPage extends StatefulWidget {
  const PlacesPage({super.key});

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  static User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: Provider.of<PlaceNotifier>(context, listen: false)
            .fetchPlaces(user.uid!),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<PlaceNotifier>(
                child: const Center(
                  child: Text("Uhhm... nothing added yet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      )),
                ),
                builder: (context, place, ch) => place.items.isEmpty
                    ? ch!
                    :
                GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        itemBuilder: (context, i) =>
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridTile(
                              footer: GridTileBar(
                                trailing: Text(timeago.format(
                                    DateTime.parse(place.items[i].time))),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: GestureDetector(
                                  onTap: () {
                                    print(place.items[i].id);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return ListenableProvider<PlaceNotifier>(
                                        create: (_) => PlaceNotifier(),
                                        builder: (context, child) {
                                          return PlaceDetailPage(
                                            lastContext: context,
                                            id: place.items[i].id,
                                          );
                                        },
                                      );
                                    }));

                                  },
                                  child: Image.file(
                                    place.items[i].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        itemCount: place.items.length,
                      ),
              ),
      ),
    );
  }
}
