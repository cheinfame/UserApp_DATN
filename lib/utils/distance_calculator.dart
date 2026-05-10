import 'dart:math';

import 'package:latlong2/latlong.dart';

double calculateDistance(LatLng startCoords, LatLng endCoords) {
  const double earthRadius = 6371000; // in meters

  double startLatRadians = degreesToRadians(startCoords.latitude);
  double endLatRadians = degreesToRadians(endCoords.latitude);
  double latDiffRadians =
      degreesToRadians(endCoords.latitude - startCoords.latitude);
  double lonDiffRadians =
      degreesToRadians(endCoords.longitude - startCoords.longitude);

  double a = sin(latDiffRadians / 2) * sin(latDiffRadians / 2) +
      cos(startLatRadians) *
          cos(endLatRadians) *
          sin(lonDiffRadians / 2) *
          sin(lonDiffRadians / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}
