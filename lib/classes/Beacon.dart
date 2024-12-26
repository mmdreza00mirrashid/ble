import 'dart:math';

class Beacon {
  final String id; // Unique identifier for the beacon
  final String name; // Beacon name
  final double x; // X-coordinate of the beacon
  final double y; // Y-coordinate of the beacon
  final double z; // Z-coordinate of the beacon
  double? distance; // Calculated distance (in meters)
  final int rssiAtOneMeter;


  int? _rssi;

  Beacon({required this.id, required this.name, required this.x, required this.y, required this.z, required this.rssiAtOneMeter}); // Internal RSSI value

 

  // Getter for RSSI
  int? get rssi => _rssi;

  // Setter for RSSI that updates the distance
  set rssi(int? value) {
    _rssi = value;
    distance = _calculateDistance();
  }

  // Private method to calculate distance based on RSSI
  double _calculateDistance(
      { double pathLossExponent = 1.6}) {
    return pow(10, (rssiAtOneMeter - _rssi!) / (10 * pathLossExponent))
        .toDouble();
  }

  @override
  String toString() {
    return 'Beacon(id: $id, name: $name, position: ($x, $y), RSSI: $_rssi, Distance: $distance meters)';
  }
}

class TrilaterationResult {
  final double x;
  final double y;
  final double z;

  TrilaterationResult({required this.x, required this.y, required this.z});

  @override
  String toString() {
    return 'TrilaterationResult(x: $x, y: $y, z: $z)';
  }
}

TrilaterationResult? findLocationUsingTrilateration(List<Beacon> beacons) {
  if (beacons.length < 3) {
    throw ArgumentError(
        'At least three beacons are required for trilateration.');
  }

  // Select three beacons
  final beacon1 = beacons[0];
  final beacon2 = beacons[1];
  final beacon3 = beacons[2];

  // Ensure all distances are available
  if (beacon1.distance == null ||
      beacon2.distance == null ||
      beacon3.distance == null) {
    throw ArgumentError('All beacons must have calculated distances.');
  }

  // Extract positions and distances
  final x1 = beacon1.x, y1 = beacon1.y, z1 = beacon1.z, r1 = beacon1.distance!;
  final x2 = beacon2.x, y2 = beacon2.y, z2 = beacon2.z, r2 = beacon2.distance!;
  final x3 = beacon3.x, y3 = beacon3.y, z3 = beacon3.z, r3 = beacon3.distance!;

  // Calculate the differences between beacons
  final ex = normalizeVector(x2 - x1, y2 - y1, z2 - z1);
  final i = dotProduct(ex, [x3 - x1, y3 - y1, z3 - z1]);

  final temp = [
    x3 - x1 - i * ex[0],
    y3 - y1 - i * ex[1],
    z3 - z1 - i * ex[2],
  ];
  final ey = normalizeVector(temp[0], temp[1], temp[2]);
  final ez = crossProduct(ex, ey);

  final d = euclideanDistance(x1, y1, z1, x2, y2, z2);
  final j = dotProduct(ey, [x3 - x1, y3 - y1, z3 - z1]);

  // Trilateration formulas
  final x = (pow(r1, 2) - pow(r2, 2) + pow(d, 2)) / (2 * d);
  final y =
      (pow(r1, 2) - pow(r3, 2) + pow(i, 2) + pow(j, 2)) / (2 * j) - (i / j) * x;
  final zSquared = pow(r1, 2) - pow(x, 2) - pow(y, 2);

  if (zSquared < 0) {
    // No valid intersection
    return null;
  }

  final z = sqrt(zSquared);

  // Return the result in 3D coordinates
  return TrilaterationResult(
    x: x1 + x * ex[0] + y * ey[0] + z * ez[0],
    y: y1 + x * ex[1] + y * ey[1] + z * ez[1],
    z: z1 + x * ex[2] + y * ey[2] + z * ez[2],
  );
}

List<double> normalizeVector(double x, double y, double z) {
  final magnitude = sqrt(x * x + y * y + z * z);
  return [x / magnitude, y / magnitude, z / magnitude];
}

double euclideanDistance(
    double x1, double y1, double z1, double x2, double y2, double z2) {
  return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2) + pow(z2 - z1, 2));
}

List<double> crossProduct(List<double> v1, List<double> v2) {
  return [
    v1[1] * v2[2] - v1[2] * v2[1],
    v1[2] * v2[0] - v1[0] * v2[2],
    v1[0] * v2[1] - v1[1] * v2[0],
  ];
}

double dotProduct(List<double> v1, List<double> v2) {
  return v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2];
}
