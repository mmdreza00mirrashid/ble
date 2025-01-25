import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class PopUp {
  static void show(
      BuildContext context, String message, AnimatedSnackBarType? messageType) {
    AnimatedSnackBar.material(
      message,
      type: messageType ?? AnimatedSnackBarType.info,
      duration: const Duration(seconds: 6),
      mobilePositionSettings: const MobilePositionSettings(
        topOnAppearance: 25,
      ),
      mobileSnackBarPosition: MobileSnackBarPosition.top,
      desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
    ).show(context);
  }
}
