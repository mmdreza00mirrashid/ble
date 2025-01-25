

import 'package:ble/Exceptions/CustomException.dart';

class CloudStorageException extends CustomException {

  CloudStorageException({required super.message, String? super.statusCode});



  @override
  String toString() {
    return message ?? 'CloudStorageException';
  }
}
