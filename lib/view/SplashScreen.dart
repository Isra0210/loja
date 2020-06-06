//testar conexão

import '../utils/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:shop/utils/AppRoutes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () => setState(
        () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_HOME);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: Image.asset(
                  'assets/image/logo.png',
                  height: 300,
                ),
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
