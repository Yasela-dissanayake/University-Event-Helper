import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'faculty.dart';
import 'faculty_data.dart';
import 'location_service.dart';
import 'event_scraper.dart';
import 'dart:math';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371e3; // Earth's radius in meters
  final phi1 = lat1 * pi / 180;
  final phi2 = lat2 * pi / 180;
  final deltaPhi = (lat2 - lat1) * pi / 180;
  final deltaLambda = (lon2 - lon1) * pi / 180;

  final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
      cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  final distance = R * c; // in meters
  return distance;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await fetchAndUpdateEvents();
  runApp(MyApp());
}

Future<void> fetchAndUpdateEvents() async {
  for (var faculty in faculties) {
    try {
      var events = await fetchEvents(faculty.url, faculty.selectors);
      faculty.events.addAll(events);
    } catch (e) {
      print('Failed to fetch events for ${faculty.name}: $e');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faculty Events',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _locationService = LocationService();
  Faculty? _nearbyFaculty;
  bool _isLoading = false;
  bool _locationServicesEnabled = true;

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  void _startLocationTracking() {
    const locationInterval = Duration(seconds: 10);
    Stream.periodic(locationInterval).listen((_) {
      _checkLocation();
    });
  }

  Future<void> _checkLocation() async {
    try {
      setState(() => _isLoading = true);
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        setState(() {
          _locationServicesEnabled = false;
          _isLoading = false;
        });
        return;
      }

      Position position = await _locationService.getCurrentLocation();
      Faculty? nearbyFaculty =
          _locationService.getNearbyFaculty(position, faculties);

      if (nearbyFaculty != null && nearbyFaculty != _nearbyFaculty) {
        setState(() => _nearbyFaculty = nearbyFaculty);
      } else if (nearbyFaculty == null) {
        setState(() => _nearbyFaculty = null);
      }
    } catch (e) {
      print('Error checking location: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Faculty Events')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : !_locationServicesEnabled
              ? Center(
                  child: Text(
                      'Location services are disabled. Please enable them to use this feature.'))
              : _nearbyFaculty == null
                  ? Center(child: Text('No faculty detected nearby'))
                  : _buildEventsList(),
    );
  }

  Widget _buildEventsList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          _nearbyFaculty!.name,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ..._nearbyFaculty!.events.map((event) => Card(
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(event.description),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${event.dateTime.toString()}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
