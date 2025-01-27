// //Sizes:
import 'dart:ui';

import 'package:flutter/material.dart';

const double fontSizeSmall = 17.0;
const double fontIconSmall = 12.0;
const double coefXspaceSmall = 0.005;
const double coefYspaceSmall = 0.015;
const double coefYspaceBig = 0.042;
const double verticalPadding = 2.0;
const double horizontalPadding = 12.0;

// const double coefWhiteBG = 0.52;
const double coefTop = 0.17;
const double coefWhiteBG = 0.5;
const double coefTopPaddingSpace = 0.12;
const double coefWidthItems = 0.73;
const double coefHeightItems = 0.043;
const double coefBottomPaddingSpace = 0.16;

const Color darkGray = Color(0xFF7A7D7D);
const Color yellow = Color(0xFFFAA639);
const Color lightGray = Color(0xFFE7E9EA);
const Color green = Color(0xFF50B848);
const Color iconDefaultColor = Color(0xFFaba7a7);
const Color lightBlue = Color(0xFF00A9C4);
const Color purple = Colors.purple;
const Color lightPurple = Color.fromARGB(255, 193, 136, 200);
const Color red = Colors.red;
const Color lightgray30 = Color.fromARGB(73, 238, 237, 236);
const Color grayNoticBG = Color.fromARGB(255, 76, 77, 77);

enum UserRole {
  student('Strudent'),
  professor('Professor');

  final String text;
  const UserRole(this.text);
}

// UI Design parameters
late final SCREEN_WIDTH = 440;
late final SCREEN_HEIGHT = 890;

const String LOADING_ROUTE = '/loading';
const String LOGIN_ROUTE = '/';
const String REGISTER_ROUTE = '/register';
const String MENU_ROUTE = '/menu/';
const String Mode_ROUTE = '/mode/';
const String Selected_Mode_ROUTE = '/selected_mode/';
const String Settings_ROUTE = '/settings/';
const String Devices_ROUTE = '/devices/';
const String Edit_Patient_ROUTE = '/edit-patient/';
const String Add_Patient_ROUTE = '/add-patient/';
const String Edit_Doctor_ROUTE = '/edit-doctor/';
const String Edit_Nurse_ROUTE = '/edit-nurse/';
const String Choose_Patient_ROUTE = '/choose-patient/';
const String Change_Password_ROUTE = '/change-password/';
const String REPORT_ROUTE = '/reports/';
const String CHOOSE_THEM_ROUTE = '/themes/';

const String dbName = 'myStorage2.db';
const String dbStudent = 'Student';
const String dbProf = 'Professor';

const String createStudentTable = '''
CREATE TABLE IF NOT EXISTS $dbStudent  (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  birth_date TEXT,
  surname TEXT,
  educational_stage TEXT NOT NULL,
  major TEXT NOT NULL,
  gender TEXT NOT NULL,
  password TEXT NOT NULL,
   salt TEXT NOT NULL
);
''';
const String createProfessorTable = '''
CREATE TABLE IF NOT EXISTS $dbProf  (
  id TEXT PRIMARY KEY,
  surname TEXT NOT NULL,
  name TEXT NOT NULL,
  prof_id TEXT NOT NULL UNIQUE,
  faculty TEXT NOT NULL,
  room_number TEXT,
  phone_num TEXT NOT NULL,
  password TEXT NOT NULL,
  salt TEXT NOT NULL
);
''';

const String Success = 'success';
