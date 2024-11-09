import 'package:flutter/material.dart';
import 'package:flutter_application_1/register.dart';
import 'package:flutter_application_1/taskbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  List listuser = [];
  bool buttondisable = true;

  Future login() async {
    print(email.text);
    try {
      final kirim = await http.post(
      Uri.parse('http://192.168.1.6/wowitem/public/api/login'),
      body: {
        'email': email.text,
        'password': password.text,
      }
    );

    print(kirim.body);

    if (kirim.statusCode == 200) {
      int user = int.parse(kirim.body);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NavigationBarApp(iduser: user)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("email or password is wrong")),
      );
    }
    } catch (e) {
      print("Error: $e");
    }
    
  }

  Future GetData() async {
    print(email.text);
    print(password.text);
    try {
      final response =
          await http.get(Uri.parse("http://192.168.1.6/wowitem/public/api/user"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          listuser = data;
        });
      }
    } catch (e) {}
  }

  void initState() {
    super.initState();
    password.addListener(_validateInput);
    email.addListener(_validateInput);
    GetData();
  }

  void _validateInput() {
    final isValid = formkey.currentState?.validate() ?? false;
    setState(() {
      buttondisable = !isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bg/item.png"),
                    fit: BoxFit.cover)),
            child: CircleAvatar(
              radius: 50,
              backgroundColor:
                  Colors.grey[200], // Warna background jika gambar tidak ada
              child: ClipOval(
                child: Image.asset(
                  'assets/icon.png',
                  width: 100, // Tinggi dan lebar yang sama dengan diameter
                  height: 150,
                  fit: BoxFit.cover, // Membuat gambar memenuhi lingkaran
                ),
              ),
            ),
          ),
          Container(
            height: 700,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
            ),
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: formkey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text("Sign in",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w300,
                          color: Colors.blue[600])),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Input must requaiired';
                      }
                      return null;
                    },
                    controller: email,
                    decoration: InputDecoration(
                        hintText: "masukan email",
                        labelText: 'enter your email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Input must requaiired';
                      }
                      return null;
                    },
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'enter your Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: buttondisable
                          ? null
                          : () {
                              // GetData();

                              // int idUser = 0;
                              login();
                            //   bool userfound = false;

                            //   for (final user in listuser) {
                            //     if (email.text == user['email']
                            //     ) {
                            //       idUser = user['id'];
                            //       userfound = true;
                            //       Navigator.push(context,
                            // MaterialPageRoute(builder: (context) => NavigationBarApp(iduser: idUser)));
                            //     }
                            //   }
                            //   if(userfound == false){
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(content: Text("user undefined")),
                            //     );
                            //   }
                              
                            },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600]),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("you dont have account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: Text(
                          "sign up here",
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
