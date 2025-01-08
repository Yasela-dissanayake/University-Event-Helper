import 'package:event_helper/src/app.dart';
import 'package:event_helper/src/provider/service_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: const MaterialApp(home: App(), debugShowCheckedModeBanner: false),
    ),
  );
}
