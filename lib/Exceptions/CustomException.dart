import 'package:ble/Material/constants.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart'
    show AnimatedSnackBarType;
import 'package:ble/Utilities/popUp.dart';
import 'package:flutter/material.dart';

class CustomException implements Exception {
  final String? message;

  String? statusCode;

  CustomException({required this.message, this.statusCode});

  void showError(BuildContext context) {
    String code = (statusCode == null || statusCode == Success)
        ? ''
        : 'Code ${statusCode}\n';
    PopUp.show(
        context,
        '${code}${message}',
        (statusCode == null)
            ? AnimatedSnackBarType.warning
            : (statusCode == Success)
                ? AnimatedSnackBarType.success
                : AnimatedSnackBarType.error);
    // AnimatedSnackBar.material(
    //   'Code ${statusCode ?? 000}: $message',
    //   type: (statusCode == null)
    //       ? AnimatedSnackBarType.warning
    //       : AnimatedSnackBarType.error,
  }

  @override
  String toString() {
    return message ?? 'AuthException';
  }
}
