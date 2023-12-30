import 'package:flutter/material.dart';
import 'package:grab/controller/auth_controller.dart';
import 'package:grab/data/model/customer_model.dart';
import 'package:grab/presentations/screens/my_rides_screen.dart';
import 'package:grab/presentations/screens/promotions_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ProfileHomeScreen extends StatelessWidget {
  ProfileHomeScreen({Key? key}) : super(key: key);
  //current user
  final AuthController _authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    CustomerModel? customer = AuthController.instance.customer;
    print(customer!.id);
    return Drawer(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(color: Colors.red),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/profile.jpg',
                        height: 58,
                        width: 58,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(100),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.white.withOpacity(1)),
                          borderRadius: radius(100)),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              customer!.name,
                              style: boldTextStyle(
                                  color: Colors.white.withOpacity(1), size: 18),
                            ),
                            Text(
                              customer.phoneNumber,
                              style: boldTextStyle(
                                color: Color(0xFFD5D5D5).withOpacity(1),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            finish(context);
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        )
                      ],
                    )
                  ],
                )),
            ListTile(
              minLeadingWidth: 0,
              title: Text('My rides', style: boldTextStyle()),
              leading: IconButton(
                icon: Icon(
                  Icons.access_time,
                  color: Color(0xFF8d9cb2),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyRidesScreen()),
                  );
                },
              ),
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text('Promotion', style: boldTextStyle()),
              leading: IconButton(
                icon: Icon(
                  Icons.discount_outlined,
                  color: Color(0xFF8d9cb2),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PromotionsScreen()),
                  );
                },
              ),
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text('My Favorite', style: boldTextStyle()),
              leading: IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Color(0xFF8d9cb2),
                ),
                onPressed: () {
                  finish(context);
                },
              ),
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text('My  payment', style: boldTextStyle()),
              leading: IconButton(
                icon: Icon(
                  Icons.payment,
                  color: Color(0xFF8d9cb2),
                ),
                onPressed: () {
                  finish(context);
                },
              ),
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text('Notification', style: boldTextStyle()),
              leading: IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF8d9cb2),
                ),
                onPressed: () {
                  finish(context);
                },
              ),
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text('Support', style: boldTextStyle()),
              leading: IconButton(
                icon: Icon(
                  Icons.contact_support_outlined,
                  color: Color(0xFF8d9cb2),
                ),
                onPressed: () {
                  finish(context);
                },
              ),
            ),
            ListTile(
              minLeadingWidth: 0,
              title: Text('Sign out', style: boldTextStyle()),
              leading: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Color(0xFF8d9cb2),
                ),
                onPressed: () {
                  _authController.signOut();
                },
              ),
            ),
          ]),
    );
  }
}
