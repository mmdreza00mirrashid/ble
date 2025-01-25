import '../Material/components.dart';
import '../Material/constants.dart';

import 'package:flutter/material.dart';


void acceptRules(ValueNotifier<bool> selectedController) {
  selectedController.value = !selectedController.value;
}

extension RegisterFormExtension on Widget {
  Widget registerFormWidget(
    BuildContext context,
    TextEditingController passController,
    TextEditingController passConfController,
    ValueNotifier<bool> checkboxController,
    VoidCallback loginFunction,
  ) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    double rowSpace = heightDevice * coefYspaceSmall;

    return Flexible(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextField(
            hintText: "Password",
            controller: passController,
            autocorrect: false,
            enableSuggestions: false,
            obscure: true,
          ),
          SizedBox(height: rowSpace),
          CustomTextField(
            hintText: "Password Confirmation",
            controller: passConfController,
            autocorrect: false,
            enableSuggestions: false,
            obscure: true,
          ),
          SizedBox(height: rowSpace),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomCheckbox(
              text: "I have read and accept rules",
              controller: checkboxController,
              width: widthDevice,
              onTap: () => acceptRules(checkboxController),
            ),
          ),
          SizedBox(height: rowSpace),
          CustomButton(text: "Create Account", onPressed: loginFunction),
        ],
      ),
    ));
  }
}
