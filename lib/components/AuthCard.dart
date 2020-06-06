import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/AuthException.dart';
import 'package:shop/providers/Auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Algo deu errado!'),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save(); //chama o onSaved de cada textField

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await auth.login(
          _authData["email"],
          _authData["password"],
        );
      } else {
        await auth.signup(
          _authData["email"],
          _authData["password"],
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Ocorreu um erro inesperado!");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: _authMode == AuthMode.Login ? 260 : 340,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty ||
                      !value.contains('@') ||
                      value.length < 10) {
                    return "Informe um e-mail válido!";
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                controller: _passwordController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || value.length <= 5) {
                    return "Informe uma senha válida!";
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value != _passwordController.text) {
                            return "Senhas são diferentes!";
                          }
                          return null;
                        }
                      : null,
                ),
              Spacer(),
              _isLoading
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.yellow),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                      _authMode != AuthMode.Login ? 'LOGIN' : 'REGISTRAR',
                    ),
                  ),
                  !_isLoading
                      ? RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          child: Text(
                            _authMode == AuthMode.Login
                                ? 'ENTRAR'
                                : 'REGISTRAR',
                            style: TextStyle(color: Colors.yellow[400]),
                          ),
                          onPressed: _submit,
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
