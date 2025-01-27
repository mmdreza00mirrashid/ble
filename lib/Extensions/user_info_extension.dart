import '../Material/constants.dart';
import 'package:flutter/material.dart';
import '../Material/components.dart';

void acceptRules(ValueNotifier<bool> selectedController) {
  selectedController.value = !selectedController.value;
}

extension ProfInfoExtension on Widget {
  Widget ProfInfoWidget(
    BuildContext context,
    TextEditingController idController,
    TextEditingController sirnameController,
    TextEditingController nameController,
    TextEditingController profIdController,
    TextEditingController facultyController,
    TextEditingController roomController,
    TextEditingController phoneNumController,
    TextEditingController passController,
    TextEditingController passConfController,
    ValueNotifier<bool> checkboxController,
    VoidCallback loginFunction,
  ) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    double rowSpace = heightDevice * coefYspaceSmall;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextField(
          hintText: "ID",
          controller: idController,
        ),
        SizedBox(height: rowSpace),
        CustomTextField(
          hintText: "Surname",
          controller: sirnameController,
        ),
        SizedBox(height: rowSpace),
        CustomTextField(
          hintText: "Name",
          controller: nameController,
        ),
        SizedBox(height: rowSpace),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: CustomTextField(
                hintText: "Faculty",
                controller: facultyController,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 3,
              child: CustomTextField(
                hintText: "Room Number",
                controller: roomController,
              ),
            ),
          ],
        ),
        SizedBox(height: rowSpace),
        CustomTextField(
          hintText: "Uni Validation Id",
          controller: profIdController,
        ),
        SizedBox(height: rowSpace),
        CustomTextField(
          hintText: "Phone Number",
          controller: phoneNumController,
        ),
        SizedBox(height: rowSpace),
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
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: CustomCheckbox(
            text: "I have read and accept the rules",
            controller: checkboxController,
            width: widthDevice,
            onTap: () => acceptRules(checkboxController),
          ),
        ),
        SizedBox(height: rowSpace),
        CustomButton(text: "Create Account", onPressed: loginFunction),
      ],
    );
  }
}

extension StudentInfoExtension on Widget {
  Widget StudentInfoWidget(
    BuildContext context,
    TextEditingController idController,
    TextEditingController educationalStageController,
    TextEditingController nameController,
    TextEditingController datecontroller,
    TextEditingController sirnameController,
    TextEditingController majorController,
    ValueNotifier<String> genderController,
    TextEditingController passController,
    TextEditingController passConfController,
    ValueNotifier<bool> checkboxController,
    VoidCallback loginFunction,
  ) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    double widthField = widthDevice * coefWidthItems;
    double heightField = heightDevice * coefHeightItems;
    double rowSpace = heightDevice * coefYspaceSmall;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextField(
          hintText: "ID",
          // width: widthField,
          // height: heightField,
          controller: idController,
        ),
        SizedBox(height: rowSpace),
        CustomTextField(
          hintText: "SurName",
          // height: heightField,
          controller: sirnameController,
        ),
        SizedBox(height: rowSpace),
        CustomTextField(
          hintText: "Name",
          height: heightField,
          controller: nameController,
        ),
        SizedBox(height: rowSpace),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: CustomDateField(
                hintText: "Birth Date",
                height: heightField,
                controller: datecontroller,
              ),
            ),
            Expanded(
              flex: 3,
              child: CustomDropdownMenu(
                options: const ['Male', 'Female'],
                selectedOption: genderController,
                hintText: "Gender",
              ),
            ),
          ],
        ),
        SizedBox(height: rowSpace),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // flex: 3,
              child: CustomTextField(
                hintText: "Major",
                // height: heightField,
                controller: majorController,
              ),
            ),
            Expanded(
              // flex: 2,
              child: CustomTextField(
                hintText: "Educational Stage",
                // height: heightField,
                controller: educationalStageController,
              ),
            ),
          ],
        ),
        SizedBox(height: rowSpace),
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
    );
  }
}

extension NurseInfoExtension on Widget {
  Widget NurseInfoWidget(
    BuildContext context,
    TextEditingController idController,
    TextEditingController sirnameController,
    TextEditingController nameController,
    TextEditingController clinicNameController,
    TextEditingController clinicIDController,
    TextEditingController phoneNumController,
    TextEditingController passController,
    TextEditingController passConfController,
    ValueNotifier<bool> checkboxController,
    VoidCallback loginFunction,
  ) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    double widthField = widthDevice * coefWidthItems;
    double heightField = heightDevice * coefHeightItems;
    double rowSpace = heightDevice * coefYspaceSmall;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextField(
          hintText: "ID",
          // width: widthField,
          // height: heightField,
          controller: idController,
        ),
        SizedBox(height: rowSpace),
        CustomTextField(
          hintText: "Surname",
          // height: heightField,
          controller: sirnameController,
        ),
        SizedBox(height: rowSpace),
        CustomTextField(
          hintText: "Name",
          // height: heightField,
          controller: nameController,
        ),
        SizedBox(height: rowSpace),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: CustomTextField(
                hintText: "Clinic Name",
                // width: widthField,
                // height: heightField,
                controller: clinicNameController,
              ),
            ),
            Expanded(
              flex: 3,
              child: CustomTextField(
                hintText: "Clinic ID",
                // height: heightField,
                controller: clinicIDController,
              ),
            ),
          ],
        ),
        SizedBox(height: rowSpace),
        CustomTextField(
          hintText: "Phone Number",
          // width: widthField,
          // height: heightField,
          controller: phoneNumController,
        ),
        SizedBox(height: rowSpace),
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
    );
  }
}
