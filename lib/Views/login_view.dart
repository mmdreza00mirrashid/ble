import 'dart:developer' as dev;
import '../Material/components.dart';
import '../Material/constants.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(seconds: 1), // Duration for the fade-in effect
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(
            children: [
              SizedBox(height: heightDevice * coefYspaceSmall),
              SizedBox(
                height: (coefWhiteBG - coefYspaceSmall) * heightDevice,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                width: widthDevice * 0.7,
                                child: Image.asset(
                                  "assets/bgDecoration.jpg",
                                  fit: BoxFit.contain, // Maintain aspect ratio
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Center(
                                        child: Text(
                                            'Image not found')); // Handle image loading error
                                  },
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Center(
                                  child: SizedBox(
                                    width: widthDevice * 0.5,
                                    child: Image.asset(
                                      "assets/name.png",
                                      fit: BoxFit.contain,
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return Center(
                                            child: Text(
                                                'Project Logo placeHolder'));
                                      },
                                    ),
                                  ), 
                                ),
                                SizedBox(height: heightDevice * coefYspaceBig),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _MyFormState();
}

class _MyFormState extends State<LoginForm> {
  String _id = '';
  String _password = '';
  String _errorMessage = '';
  final idController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      _id = idController.text.trim();
      _password = passController.text.trim();

      Navigator.of(context).pushNamedAndRemoveUntil(
        MENU_ROUTE,
        (_) => false,
      );

      dev.log("User logged in: ${_id} , ${_password}");
    } catch (e) {
      dev.log(e.toString(), name: "Login page");
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double widthField = widthDevice * coefWidthItems;
    double heightField = deviceHeight * coefHeightItems;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: deviceHeight * coefYspaceBig),
        CustomTextField(
          hintText: "ID",
          controller: idController,
          isFilled: false,
        ),
        SizedBox(height: deviceHeight * coefYspaceSmall),
        CustomTextField(
          hintText: "Password",
          isFilled: false,
          autocorrect: false,
          enableSuggestions: false,
          controller: passController,
          obscure: true,
        ),
        SizedBox(height: deviceHeight * coefYspaceSmall),
        CustomButton(
          text: "Login",
          width: widthDevice,
          onPressed: _login,
        ),
        SizedBox(height: deviceHeight * coefYspaceSmall),
        CustomButton(
            text: "Create Account",
            width: widthDevice,
            onPressed: () {
              dev.log("pushed");
              Navigator.of(context).pushNamed(
                REGISTER_ROUTE,
              );
            }),
        SizedBox(height: deviceHeight * coefYspaceSmall),
        Opacity(
          opacity: 0.6,
          child: TextButton(
            onPressed: () {},
            child: Text("Forgot password?"),
          ),
        ),
        // CustomButton(
        //   text: "Forgot password?",
        //   width: widthDevice,
        //   fontSize: 15.0,
        //   isDisabled: true,
        //   // height: heightField,
        //   hasBorder: false,
        // ),
      ],
    );
  }
}
