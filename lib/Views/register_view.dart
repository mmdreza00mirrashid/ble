import 'dart:developer' as dev show log;

import 'package:ble/Exceptions/Auth_exception.dart';

import '../Extensions/user_info_extension.dart';
import '../Material/components.dart';
import '../Material/constants.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  UserRole selectedRole = UserRole.professor;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController clinicIDController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  final TextEditingController drController = TextEditingController();
  final TextEditingController clinicController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController sirnameController = TextEditingController();
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final genderController = ValueNotifier<String>("");
  final ValueNotifier<bool> checkboxController = ValueNotifier<bool>(false);

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleRegisterButtonPressed() async {
    try {
      if (!checkboxController.value) {
        throw AuthException(message: "agree to the terms of service");
      }
      if (passwordController.text != passwordConfirmController.text) {
        throw AuthException(message: "password confirmation is wrong");
      }
      // switch (selectedRole) {
      //   case UserRole.patient:
      //     await _authService.patientRegistration(
      //       idController,
      //       passwordController,
      //       heightController,
      //       nameController,
      //       datecontroller,
      //       sirnameController,
      //       weightController,
      //       genderController.value,
      //       UserRole.patient,
      //     );
      //     break;
      //   case UserRole.doctor:
      //     await _authService.doctorRegistration(
      //       idController,
      //       passwordController,
      //       nameController,
      //       drController,
      //       clinicNameController,
      //       clinicIDController,
      //       phoneNumController,
      //       sirnameController,
      //       UserRole.doctor,
      //     );
      //     break;
      //   case UserRole.physiotherapist:
      //     await _authService.doctorRegistration(
      //       idController,
      //       passwordController,
      //       nameController,
      //       drController,
      //       clinicNameController,
      //       clinicIDController,
      //       phoneNumController,
      //       sirnameController,
      //       UserRole.physiotherapist,
      //     );
      //     break;
      //   default:
      // }
      dev.log("Name: ${nameController.text}");
      dev.log("Password: ${passwordController.text}");
    } on AuthException catch (e) {
      e.showError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final heightDevice = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: ImageIcon(
                  size: 30.0,
                  AssetImage("assets/professor.png"),
                ),
                iconMargin: EdgeInsets.all(5.0),
                text: "professor",
              ),
              Tab(
                icon: ImageIcon(
                  size: 30.0,
                  AssetImage("assets/student.png"),
                ),
                iconMargin: EdgeInsets.all(5.0),
                text: "student",
              ),
            ],
          ),
          title: const Text('Create Account'),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: heightDevice * coefYspaceSmall,
                ),
                Container().ProfInfoWidget(
                  context,
                  idController,
                  sirnameController,
                  nameController,
                  drController,
                  clinicNameController,
                  clinicIDController,
                  phoneNumController,
                  passwordController,
                  passwordConfirmController,
                  checkboxController,
                  handleRegisterButtonPressed,
                ),
              ]),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: heightDevice * coefYspaceSmall,
                  ),
                  Container().StudentInfoWidget(
                    context,
                    idController,
                    heightController,
                    nameController,
                    datecontroller,
                    sirnameController,
                    weightController,
                    genderController,
                    passwordController,
                    passwordConfirmController,
                    checkboxController,
                    handleRegisterButtonPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
