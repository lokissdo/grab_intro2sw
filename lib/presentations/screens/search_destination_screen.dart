import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
//import 'package:http/http.dart';

class SearchDestinationceScreen extends StatefulWidget {
  const SearchDestinationceScreen({Key? key}) : super(key: key);

  @override
  State<SearchDestinationceScreen> createState() =>
      _SearchDestinationceScreenState();
}

class _SearchDestinationceScreenState extends State<SearchDestinationceScreen> {
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
                child: TextFormField(
                  onChanged: (value) {
                    //placeAutocomplete(value);
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                      hintText: 'location from',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SvgPicture.asset(
                          "assets/icons/location_from.svg",
                        ),
                      )),
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
                child: TextFormField(
                  onChanged: (value) {},
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'location to',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: SvgPicture.asset(
                        "assets/icons/location_to.svg",
                      ),
                    ),
                  ),
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
