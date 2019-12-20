import 'package:flutter/material.dart';
import 'package:instagram_application/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  static String id = "signup_screen";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textFormFieldName = TextEditingController();
  final _textFormFieldEmail = TextEditingController();
  final _textFormFieldPassword = TextEditingController();
  String _name;
  String _email;
  String _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ekranı"),
      ),
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
                        controller: _textFormFieldName,
                        decoration: InputDecoration(
                          labelText: "  Adınızı Giriniz",
                          labelStyle: TextStyle(fontSize: 20),
                          errorStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          prefixIcon: Icon(
                            Icons.person,
                            size: 35,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        validator: (input) => input.trim().isEmpty
                            ? 'Please enter a valid name'
                            : null,
                        onSaved: (value) {
                          _name = value;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _textFormFieldEmail,
                        decoration: InputDecoration(
                          labelText: "  Email Giriniz",
                          labelStyle: TextStyle(fontSize: 20),
                          errorStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                        onSaved: (value) {
                          _email = value;
                        },
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email'
                            : null,
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
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                        validator: (input) => input.length < 6
                            ? 'Must be at least 6 characters'
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
                                _textFormFieldName.clear();
                                _textFormFieldEmail.clear();
                                _textFormFieldPassword.clear();
                              },
                              child: Text(
                                "Kayıt",
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
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Geri Dön",
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

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      AuthService.signUpUser(context, _name, _email, _password);
      debugPrint("Kullanıcı Başarıyla Eklendi.");
    } else {
      debugPrint("Kullanıcı Oluşturmada Hata Meydana Geldi.");
    }
  }
}
