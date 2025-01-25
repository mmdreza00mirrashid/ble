import 'package:ble/Utilities/namedRouteHandler.dart';
import 'package:ble/Views/device_list_view.dart';
import 'package:ble/classes/Beacon.dart';
import 'package:ble/classes/devices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'BLE Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: routeHandler,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      );
}


