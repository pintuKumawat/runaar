import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:runaar/core/services/api_response.dart';

class DefaultImage {
  DefaultImage._();

  static const String _defaultUser = "assets/images/default_profile.jpg";

  CircleAvatar userProvider(String? url, double radius) {
    if (url == null || url.isEmpty || url == "") {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: .circular(radius),
          child: Image.asset(_defaultUser, fit: .cover,)),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      backgroundImage: CachedNetworkImageProvider(
        "${apiMethods.baseUrl}/$url",
        errorListener: (image) => CircleAvatar(
          radius: radius,
          backgroundColor: Colors.transparent,
          child: ClipRRect(
          borderRadius: .circular(radius),
          child: Image.asset(_defaultUser, fit: .cover,)),
        ),
      ),
    );
  }
}

final DefaultImage defaultImage = DefaultImage._();
