import 'package:event_helper/src/app.dart';
import 'package:event_helper/src/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: const MaterialApp(home: App()),
    ),
  );
}
