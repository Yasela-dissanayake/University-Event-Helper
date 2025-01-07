import 'package:event_helper/src/models/faculty.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../models/faculty_event.dart';

class ServiceProvider extends ChangeNotifier {
  final double _detectionRadiusMeters = 500000000.0;
  final String _wifiSsid = 'UoP-WiFi';

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

  void _getFacultyData() {
    _allFacultyData = [
      Faculty(
        name: 'Faculty of Medicine',
        latitude: 6.999719955566542, // Replace with actual coordinates
        longitude: 81.09608239052262,
        events: [
          FacultyEvent(
            title: 'Med Symposium',
            description: 'Research presentation by faculty members',
            dateTime: DateTime(2024, 12, 18, 10, 0),
          ),
        ],
      ),

      Faculty(
        name: 'Faculty of Science',
        latitude: 6.998938727012407, // Replace with actual coordinates
        longitude: 81.09564610780035,
        events: [
          FacultyEvent(
            title: 'Science Symposium',
            description: 'Research presentation by faculty members',
            dateTime: DateTime(2024, 12, 18, 10, 0),
          ),
        ],
      ),

      Faculty(
        name: 'Faculty of Engineering',
        latitude: 6.999041888112743, // Replace with actual coordinates
        longitude: 81.09534570038534,
        events: [
          FacultyEvent(
            title: 'Engineering Exhibition',
            description: 'Annual project showcase by final year students',
            dateTime: DateTime(2024, 12, 15, 9, 0),
          ),
          FacultyEvent(
            title: 'Tech Workshop',
            description: 'Workshop on emerging technologies',
            dateTime: DateTime(2024, 12, 20, 14, 0),
          ),
        ],
      ),
      // Add more faculties as needed
    ];
  }

  Future<void> _update() async {
    await _getCurrentLocation();
    _getFacultyData();
    _updateNearbyFaculty();
    notifyListeners();
  }
}
