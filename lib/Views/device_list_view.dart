import 'dart:async';
import 'dart:convert';
import 'package:ble/Material/backDialog.dart';
import 'package:ble/Material/constants.dart';
import 'package:ble/classes/devices.dart';
import 'package:ble/main.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import '../Material/components.dart';

class DeviceListPage extends State<MyHomePage> {
  final _writeController = TextEditingController();
  int rssiAtOneMeter = -59;
  double pathLossExponent = 2.0;
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];
  final List<String> _beaconId = [
    'A0:B7:65:DD:79:FE',
    'B0:B2:1C:A7:20:86',
    'B0:A7:32:DB:08:2E',
    '3C:71:BF:96:F6:76',
  ];
  late final StreamSubscription<List<ScanResult>> subscription;

  bool isLoading = false;

  _addDeviceTolist(final DeviceWrapper device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  _clearDeviceList() {
    setState(() {
      widget.devicesList.clear();
    });
  }

  num calculateDistance(int rssi,
      {int rssiAtOneMeter = -61, double pathLossExponent = 2.0}) {
    return pow(10, (rssiAtOneMeter - rssi) / (10 * pathLossExponent));
  }

  void _initBluetooth() async {
    subscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          widget.devicesList
              .clear(); // Clear the list to update it with fresh data
          for (ScanResult result in results) {
            dev.log(result.device.toString(), name: 'list');
            dev.log(result.rssi.toString(), name: 'rssi');

            final rssi = result.rssi;
            final distance = calculateDistance(
              rssi,
              rssiAtOneMeter: rssiAtOneMeter,
              pathLossExponent: pathLossExponent,
            );

            DeviceWrapper temp = DeviceWrapper(device: result.device);
            temp.rssi = rssi;
            temp.distance = distance.toDouble();

            // Log the device information
            // dev.log(
            //   'Beacon: $beaconId, RSSI: $rssi, Distance: $distance meters',
            //   name: 'beacon',
            // );

            // Update the device list
            _addDeviceTolist(temp);
          }
        }
      },
      onError: (e) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      ),
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    // Wait for Bluetooth adapter to turn on
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    // Start scanning
    await FlutterBluePlus.startScan(
        withRemoteIds: _beaconId, continuousUpdates: true);

    // Wait until scanning stops
    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    // Add connected devices to the list
    FlutterBluePlus.connectedDevices.forEach((device) {
      _addDeviceTolist(DeviceWrapper(device: device));
    });
  }

  @override
  void initState() {
    () async {
      var status = await Permission.location.status;
      if (status.isDenied) {
        final status = await Permission.location.request();
        if (status.isGranted || status.isLimited) {
          _initBluetooth();
        }
      } else if (status.isGranted || status.isLimited) {
        _initBluetooth();
      }

      if (await Permission.location.status.isPermanentlyDenied) {
        openAppSettings();
      }
    }();
    super.initState();
  }

  ListView _buildListViewOfDevices() {
    List<Widget> containers = <Widget>[];
    for (DeviceWrapper o in widget.devicesList) {
      containers.add(
        SizedBox(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(o.device.platformName == ''
                        ? '(unknown device)'
                        : o.device.advName),
                    Text(o.device.remoteId.toString()),
                  ],
                ),
              ),
              CustomButton(
                  text: "Show Details",
                  width: 150,
                  textColor: Colors.white,
                  onPressed: () {
                    // FlutterBluePlus.stopScan();
                    // try {
                    subscription.pause();

                    o.distance = calculateDistance(o.rssi!,
                            rssiAtOneMeter: rssiAtOneMeter,
                            pathLossExponent: pathLossExponent)
                        .toDouble();
                    showMessage(context,
                        "DeviceId:${o.device.remoteId} \n rssi :${o.rssi} \ndistance: ${o.distance}");

                    dev.log(
                        "${o.device.remoteId} \n rssi :${o.rssi} \ndistance: ${o.distance}\n$rssiAtOneMeter , $pathLossExponent");
                    _clearDeviceList();
                    subscription.resume();

                  }),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              child: const Text('READ', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                var sub = characteristic.lastValueStream.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: const Text('WRITE', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Send"),
                            onPressed: () {
                              characteristic.write(
                                  utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child:
                  const Text('NOTIFY', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                characteristic.lastValueStream.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  ListView _buildConnectDeviceView() {
    List<Widget> containers = <Widget>[];

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = <Widget>[];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                            'Value: ${widget.readValues[characteristic.uuid]}')),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        ExpansionTile(
            title: Text(service.uuid.toString()),
            children: characteristicsWidget),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }

  Future<void> _refreshContent() async {
    _clearDeviceList();
    _initBluetooth();
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Wait for 3 seconds
    await Future.delayed(Duration(seconds: 1));

    // Hide the loading indicator
    Navigator.pop(context);

    // Update the state with refreshed content
    // setState(() {
    //   _message = "Content refreshed at ${DateTime.now()}";
    // });
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Devices'),
        backgroundColor: Colors.blue, // Set the background color to blue
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshContent, // Custom onPressed function
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: heightDevice * (coefWhiteBG),
                  child: PopScope<Object?>(
                    canPop: false,
                    onPopInvokedWithResult:
                        (bool didPop, Object? result) async {
                      if (didPop) {
                        return;
                      }

                      final bool shouldPop = await backDialog(context);
                      if (context.mounted && shouldPop) {
                        SystemNavigator.pop();
                      }
                    },
                    child: _buildView(),
                  ),
                ), // Top half
                Text(
                  widget.devicesList.length.toString(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Footer Section for sliders
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('rssiAtOneMeter: ${rssiAtOneMeter}'),
                Slider(
                  value: rssiAtOneMeter.toDouble(),
                  min: -100.0,
                  max: 0.0,
                  divisions: 100,
                  label: "$rssiAtOneMeter",
                  onChanged: (value) {
                    setState(() {
                      rssiAtOneMeter = value.round();
                    });
                  },
                ),
                SizedBox(height: 10),
                Text(
                    'pathLossExponent: ${pathLossExponent.toStringAsFixed(2)}'),
                Slider(
                  value: pathLossExponent,
                  min: 0.0,
                  max: 10.0,
                  divisions: 100,
                  label: pathLossExponent.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      pathLossExponent = double.parse(value.toStringAsFixed(1));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
