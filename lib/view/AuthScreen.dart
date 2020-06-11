import 'package:flutter/material.dart';
import 'package:shop/components/AuthCard.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
          ),
          Container(
            margin: EdgeInsets.only(top: 90),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                AuthCard(),
                Container(
                  child: Image.asset(
                    'assets/image/logo.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: 220,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
