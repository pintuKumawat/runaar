import 'package:flutter/material.dart';

class SubscriptionPlan {
  final String title;
  final String description;
  final String price;
  final String duration;
  final String rides;
 
  final bool isPopular;

  SubscriptionPlan({
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.rides,
   
    this.isPopular = false,
  });
}
