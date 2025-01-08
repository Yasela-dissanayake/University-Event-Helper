import 'package:event_helper/models/faculty.dart';
import 'package:event_helper/models/faculty_event.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:event_helper/services/firestore_service.dart';

import '../models/faculty_event.dart';

class ServiceProvider extends ChangeNotifier {
  final double _detectionRadiusMeters = 50.0;
  final String _wifiSsid = 'Katussa';

  late Position _currentPosition;
  late List<Faculty> _allFacultyData = [];
  late List<Faculty> _filteredFacultyData = [];

  List<Faculty> get filteredFacultyData => _filteredFacultyData;

  final FirebaseService _firebaseService = FirebaseService();

  ServiceProvider() {
    _firebaseService.getAllFaculties().listen((snapshot) async {
      _allFacultyData = await Future.wait(snapshot.docs.map((doc) async {
        var faculty = Faculty.fromFirestore(doc);
        var eventsSnapshot = await doc.reference.collection('events').get();
        faculty.events.addAll(eventsSnapshot.docs.map((eventDoc) => FacultyEvent.fromFirestore(eventDoc)).toList());
        return faculty;
      }).toList());
      notifyListeners();
    });
  }

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
        faculty.latitude,
        faculty.longitude,
      );

      if (distance < _detectionRadiusMeters) {
        filteredFaculties.add(faculty);
      }
    }
    _filteredFacultyData = filteredFaculties;
    notifyListeners();
  }

  Future<void> _update() async {
    await _getCurrentLocation();
    _updateNearbyFaculty();
    notifyListeners();
  }
}