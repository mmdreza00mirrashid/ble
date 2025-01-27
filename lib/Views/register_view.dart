import 'dart:developer' as dev show log;

import 'package:ble/Exceptions/Auth_exception.dart';
import 'package:ble/Services/CRUD/Storage.dart';
import 'package:ble/classes/Professor.dart';
import 'package:ble/classes/Student.dart';
import 'package:get/get.dart';

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
  final TextEditingController facultyController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  final TextEditingController profIdController = TextEditingController();
  final TextEditingController clinicController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController sirnameController = TextEditingController();
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController educationalStageController =
      TextEditingController();
  final genderController = ValueNotifier<String>("");
  StrorageService _strorageService = StrorageService();
  final ValueNotifier<bool> checkboxController = ValueNotifier<bool>(false);

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleStudentRegister() async {
    try {
      if (!checkboxController.value) {
        Get.snackbar('Warning', 'Agree to the terms of service',
            snackPosition: SnackPosition.TOP);
        return;
      }
      if (passwordController.text != passwordConfirmController.text) {
        Get.snackbar('Warning', 'password confirmation is wrong',
            snackPosition: SnackPosition.TOP);
        return;
      }
      Student newStudent = Student(
        id: idController.text,
        name: nameController.text,
        educationalStage: educationalStageController.text,
        major: majorController.text,
        gender: genderController.value,
        password: passwordController.text,
      );

      bool result = await _strorageService.addStudent(newStudent);
      if (result) {
        Get.snackbar(
            'Welcome ${nameController.text}', 'Successfully Registered',
            snackPosition: SnackPosition.TOP, backgroundColor: green);
        Navigator.of(context).pop();
      } else {
        Get.snackbar('Error', 'There was a problem registering you',
            snackPosition: SnackPosition.TOP, backgroundColor: yellow);
      }
      dev.log("Name: ${nameController.text}");
      dev.log("Password: ${passwordController.text}");
    } on AuthException catch (e) {
      e.showError(context);
    }
  }

  Future<void> handleProfRegister() async {
    try {
      if (!checkboxController.value) {
        Get.snackbar('Warning', 'Agree to the terms of service',
            snackPosition: SnackPosition.TOP);
        return;
      }
      if (passwordController.text != passwordConfirmController.text) {
        Get.snackbar('Warning', 'password confirmation is wrong',
            snackPosition: SnackPosition.TOP);
        return;
      }
      Professor newProfessor = Professor(
          id: idController.text,
          surname: sirnameController.text,
          name: nameController.text,
          profId: profIdController.text,
          faculty: facultyController.text,
          phoneNum: phoneNumController.text,
          password: passwordController.text);

      bool result = await _strorageService.addProf(newProfessor);
      if (result) {
        Get.snackbar('Welcome Professor', 'Successfully Registered',
            snackPosition: SnackPosition.TOP, backgroundColor: green);
        Navigator.of(context).pop();
      } else {
        Get.snackbar('Error', 'There was a problem registering you',
            snackPosition: SnackPosition.TOP, backgroundColor: yellow);
      }
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
                  profIdController,
                  facultyController,
                  roomController,
                  phoneNumController,
                  passwordController,
                  passwordConfirmController,
                  checkboxController,
                  handleProfRegister,
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
                    educationalStageController,
                    nameController,
                    datecontroller,
                    sirnameController,
                    majorController,
                    genderController,
                    passwordController,
                    passwordConfirmController,
                    checkboxController,
                    handleStudentRegister,
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
