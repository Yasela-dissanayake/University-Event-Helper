import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_helper/src/models/faculty.dart';
import 'package:event_helper/src/models/faculty_event.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wifi_scan/wifi_scan.dart';

class ServiceProvider extends ChangeNotifier {
  final double _detectionRadiusMeters = 500.0;
  final String _wifiSsid = 'UoP-WiFi';
  final FirebaseFirestore _firebaseService = FirebaseFirestore.instance;

  late Position _currentPosition;
  late List<Faculty> _allFacultyData;
  late List<Faculty> _filteredFacultyData = [];

  List<Faculty> get filteredFacultyData => _filteredFacultyData;

  Future<void> startScanEvents() async {
    bool scanWithLocation = await _wifiScan();

    if (scanWithLocation) {
      await _update();
    }
  }

  Future<bool> _wifiScan() async {
    bool inUop = false;
    var canStartScan = await WiFiScan.instance.canStartScan();
    if (canStartScan == CanStartScan.yes) {
      await WiFiScan.instance.startScan();
      List<WiFiAccessPoint> wifiList =
          await WiFiScan.instance.getScannedResults();
      for (var wifi in wifiList) {
        if (wifi.ssid == _wifiSsid) {
          inUop = true;
          break;
        }
      }
    }

    return inUop;
  }

  Future<void> _getCurrentLocation() async {
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

    _currentPosition = await Geolocator.getCurrentPosition();
    notifyListeners();
  }

  void _updateNearbyFaculty() {
    List<Faculty> filteredFaculties = [];
    for (var faculty in _allFacultyData) {
      double distance = Geolocator.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        faculty.latitude ?? 0.0,
        faculty.longitude ?? 0.0,
      );

      if (distance < _detectionRadiusMeters) {
        filteredFaculties.add(faculty);
      }
    }
    _filteredFacultyData = filteredFaculties;
    notifyListeners();
  }

  Future<void> _getFacultyData() async {
    List<Faculty> facultiesList = [];
    try {
      QuerySnapshot<Map<String, dynamic>> facultiesSnapshot =
          await _firebaseService.collection("faculties").get();

      for (var facultyDoc in facultiesSnapshot.docs) {
        // Extract faculty details
        String name = facultyDoc.get("name");
        double? latitude = facultyDoc.data().containsKey("latitude")
            ? facultyDoc.get("latitude")
            : null;
        double? longitude = facultyDoc.data().containsKey("longitude")
            ? facultyDoc.get("longitude")
            : null;

        // Fetch events for the current faculty
        QuerySnapshot<Map<String, dynamic>> eventsSnapshot =
            await _firebaseService
                .collection("faculties")
                .doc(facultyDoc.id)
                .collection("events")
                .get();

        // Map events to FacultyEvent objects
        List<FacultyEvent> events = eventsSnapshot.docs.map((eventDoc) {
          return FacultyEvent(
            title: eventDoc.get("title"),
            sourceUrl: eventDoc.get("source_url"),
            dateTime: eventDoc.get("date"),
          );
        }).toList();

        // Create a Faculty object
        facultiesList.add(
          Faculty(
            name: name,
            latitude: latitude,
            longitude: longitude,
            events: events,
          ),
        );
      }
    } catch (e) {
      //
    }
    _allFacultyData = facultiesList;
    notifyListeners();
  }

  Future<void> _update() async {
    await _getCurrentLocation();
    await _getFacultyData();
    _updateNearbyFaculty();
    notifyListeners();
  }
}
