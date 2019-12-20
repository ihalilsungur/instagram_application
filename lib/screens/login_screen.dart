import 'package:flutter/material.dart';
import 'package:instagram_application/screens/signup_screen.dart';
import 'package:instagram_application/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textFormFieldEmail = TextEditingController();
  final _textFormFieldPassword = TextEditingController();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Instagram",
                style: TextStyle(fontFamily: "Billabong", fontSize: 40),
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: _textFormFieldEmail,
                        decoration: InputDecoration(
                          labelText: "  Email Giriniz",
                          labelStyle: TextStyle(fontSize: 20),
                            errorStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            size: 35,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        validator: (input) => !input.contains("@")
                            ? "Lütfen Geçerli Bir Email Giriniz"
                            : null,
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _textFormFieldPassword,
                        decoration: InputDecoration(
                          labelText: "  Şifre Giriniz",
                          labelStyle: TextStyle(fontSize: 20),
                          errorStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 35,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        validator: (input) => input.length<6
                            ? "Lütfen En Az 6 Karakter Giriniz"
                            : null,
                        onSaved: (value) {
                          _password = value;
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width:
                                MediaQuery.of(context).size.width * 1 / 2 - 15,
                            child: FlatButton(
                              padding: EdgeInsets.all(18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.blue,
                              onPressed: () {
                                _submit();
                                _textFormFieldEmail.clear();
                                _textFormFieldPassword.clear();
                              },
                              child: Text(
                                "Giriş Yap",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width:
                                MediaQuery.of(context).size.width * 1 / 2 - 15,
                            child: FlatButton(
                              padding: EdgeInsets.all(18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.blue,
                              onPressed: () {
                                /*
                                  Birinci yol
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                                 */
                                Navigator.pushNamed(context, SignUpScreen.id);
                              },
                              child: Text(
                                "Kayıt Ol",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("Email : " + _email);
      print("Şifre : " + _password);
      AuthService.login(_email, _password);
    }
  }
}
