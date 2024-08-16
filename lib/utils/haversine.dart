import 'dart:math';

class HaversineFormula {
  static double distance(
      double lat1, double lon1, double lat2, double lon2) {
    const double radiusOfEarth = 6371; // Earth's radius in kilometers
    double latDistance = _toRadians(lat2 - lat1);
    double lonDistance = _toRadians(lon2 - lon1);
    double a = pow(sin(latDistance / 2), 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            pow(sin(lonDistance / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radiusOfEarth * c;

    return distance * 1000; // Convert to meters
  }

  static double _toRadians(double degree) {
    return degree * (pi / 180);
  }
}
