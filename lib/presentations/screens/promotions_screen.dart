import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grab/controller/auth_controller.dart';
import 'package:grab/data/model/address_model.dart';
import 'package:grab/data/model/customer_model.dart';
import 'package:grab/data/model/promotion_model.dart';
import 'package:grab/presentations/widget/promotion_card.dart';

class PromotionsScreen extends StatelessWidget {
  final AuthController _authController = AuthController.instance;
  List<PromotionModel> promotionList = [];

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    //retreive promotions
    CustomerModel? customer = AuthController.instance.customer;
    promotionList = customer!.promotions;
    return Scaffold(

      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 30.0,
                      ),
                    ),
                    Container(
                      height: 33.0,
                      width: 120.0,
                      margin: EdgeInsets.only(right: 10.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                      decoration: BoxDecoration(
                          color: _theme.primaryColor,
                          borderRadius: BorderRadius.circular(18.0)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.star_border,
                              size: 16.0,
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "4,625",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            " points",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "My Promotions",
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Color(0xffF1F1F1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(""),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: promotionList.length,
                  itemBuilder: (context, index) {
                    return PromotionCard(promotion: promotionList[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
