import 'package:flutter/material.dart';
import 'package:shop/components/AuthCard.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
            ),
            Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'assets/image/logo.png',
                      width: double.infinity,
                      height: 220,
                    ),
                  ),
                  // Container(
                  // transform: Matrix4.rotationZ(-20 * pi / 180)
                  //   ..translate(-60.0), //cascate operation
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(25),
                  //   color: Colors.black,
                  //   boxShadow: [
                  //     BoxShadow(
                  //       blurRadius: 8,
                  //       color: Colors.black,
                  //       offset: Offset(0, 2),
                  //     )
                  //   ],
                  // ),
                  //   child: Text(
                  //     'Camila',
                  //     style: TextStyle(
                  //         color: Colors.yellow,
                  //         fontSize: 40,
                  //         fontFamily: 'Anton',
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  AuthCard(),
                ],
              ),
            ),
          ],
        ));
  }
}
