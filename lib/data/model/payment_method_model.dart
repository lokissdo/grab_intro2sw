import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel {
  static String collectionName = 'payment_methods';

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });

  String id;
  String name;
  Timestamp createdAt;
  Timestamp updatedAt;
  bool isDeleted;

  static PaymentMethodModel fromJson(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map["id"],
      name: map["name"],
      createdAt: map["createdAt"] as Timestamp,
      updatedAt: map["updatedAt"] as Timestamp,
      isDeleted: map["isDeleted"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "isDeleted": isDeleted,
    };
  }
}
