import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/AuthException.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    } 
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC1Y1WRVZLS97gQJGd_Z9vcobrrfzECnNE'; //usando $urlSegment pois a url de login e senha seguem o mesmo modelo mudando apenaso tipo, no qual substituimos pela variavel

    final response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    final responseBody = json.decode(response.body);
    if (responseBody != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody["idToken"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseBody["expiresIn"],
          ),
        ),
      );
      notifyListeners();
    }
    print(isAuth);

    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    //Registro
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    //Login
    return _authenticate(email, password, "signInWithPassword");
  }
}
