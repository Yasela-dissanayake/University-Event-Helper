import 'package:geolocator/geolocator.dart';
import 'faculty.dart';

class LocationService {
  static const double DETECTION_RADIUS_METERS = 50.0;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Faculty? getNearbyFaculty(Position currentPosition, List<Faculty> faculties) {
    for (var faculty in faculties) {
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        faculty.latitude,
        faculty.longitude,
      );

      print('Distance to ${faculty.name}: $distance meters');

      if (distance <= DETECTION_RADIUS_METERS) {
        return faculty;
      }
    }
    return null;
  }
}
