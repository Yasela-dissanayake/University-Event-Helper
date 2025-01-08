import 'package:event_helper/screens/home_page.dart';
import 'package:event_helper/src/widgets/faculty_event_viewer.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UOP Events"),
      ),
      body: HomePage(),
    );
  }
}
