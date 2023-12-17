import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final double rating;
  final String comment;
  final Timestamp createdAt;

  FeedbackModel({
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
  Map<String, dynamic> toJson() {
  return {
    "rating": rating,
    "comment": comment,
    "createdAt": createdAt,
  };
}
  static FeedbackModel  fromJson(Map<String, dynamic> map) {
  return FeedbackModel(
    rating: map["rating"] as double,
    comment: map["comment"],
    createdAt: map["createdAt"] as Timestamp,
  );
}
}
