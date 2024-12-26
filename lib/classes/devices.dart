import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceWrapper{
 final  BluetoothDevice device;
 int? rssi;
 double? distance;

  DeviceWrapper({required this.device});
}