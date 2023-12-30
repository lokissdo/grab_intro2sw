import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grab/controller/map_controller.dart';
import 'package:grab/data/model/search_place_model.dart';
import 'package:nb_utils/nb_utils.dart';
//import 'package:http/http.dart';

class SearchDestinationceScreen extends StatefulWidget {
  const SearchDestinationceScreen({Key? key}) : super(key: key);

  @override
  State<SearchDestinationceScreen> createState() =>
      _SearchDestinationceScreenState();
}

class _SearchDestinationceScreenState extends State<SearchDestinationceScreen> {
  late List<SearchPlaceModel> searchedDestinations = [];
  late List<SearchPlaceModel> searchedPickup = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            finish(context);
          },
          constraints: const BoxConstraints.tightFor(
            width: 20,
            height: 20,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.map_outlined,
                color: Colors.black,
                size: 26,
              ))
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (address) async {
                        MapController().searchPlaces(address).then((places) => {
                              setState(() {
                                searchedPickup = places;
                              })
                            });
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          hintText: 'Enter pickup location',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SvgPicture.asset(
                              "assets/icons/location_from.svg",
                            ),
                          )),
                    ),
                    if (searchedPickup.isNotEmpty)
                      ListSearchedPlace(searchedPickup: searchedPickup),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 2,
              thickness: 2,
              color: Color(0xFFF8F8F8),
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (address) async {
                        MapController().searchPlaces(address).then((places) => {
                              setState(() {
                                searchedDestinations = places;
                              })
                            });
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Enter destination',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: SvgPicture.asset(
                            "assets/icons/location_to.svg",
                          ),
                        ),
                      ),
                    ),
                    if (searchedDestinations.isNotEmpty)
                      ListSearchedPlaces(
                          searchedDestinations: searchedDestinations),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 4,
              thickness: 4,
              color: Color(0xFFF8F8F8),
            ),
          ],
        ),
      ),
    );
  }
}

class ListSearchedPlace extends StatelessWidget {
  const ListSearchedPlace({
    super.key,
    required this.searchedPickup,
  });

  final List<SearchPlaceModel> searchedPickup;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: searchedPickup.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            // _searchDestinationController.text =
            //     _places[index].description;
            // _destinationP = _places[index].latLng;
            // _cameraToPosition(_destinationP);
            // Navigator.pop(context);
          },
          title: Text(
            searchedPickup[index].stringName,
            maxLines: 2,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

class ListSearchedPlaces extends StatelessWidget {
  const ListSearchedPlaces({
    super.key,
    required this.searchedDestinations,
  });

  final List<SearchPlaceModel> searchedDestinations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: searchedDestinations.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {},
          title: Text(
            searchedDestinations[index].stringName,
            maxLines: 2,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
