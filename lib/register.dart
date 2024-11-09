import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController notlf = TextEditingController();
  bool buttondisable = true; 
  List listuser = [];

  Future GetData() async {
    try {
      final response = await http
          .get(Uri.parse("http://192.168.1.6/wowitem/public/api/user"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          listuser = data;
        });
      }
    } catch (e) {}
  }

  Future createuser() async{
    try { 
      final response = await http
          .post(Uri.parse("http://192.168.1.6/wowitem/public/api/user"),
          body: {
          "username": username.text,
          "notlf": notlf.text,
          "email": email.text,
          "password": password.text,
        }
          );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {}
  }
  
  void initState() {
    GetData();
    super.initState();
    password.addListener(_validateInput);
    notlf.addListener(_validateInput);
    email.addListener(_validateInput);
    username.addListener(_validateInput);
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
      backgroundColor: Colors.blue[500],
      body: ListView(
        
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(image: 
              AssetImage("assets/bg/item.png"),
              fit: BoxFit.cover)
            ),
            child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200], // Warna background jika gambar tidak ada
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
              borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
            ),
            padding: EdgeInsets.all(20.0),
            
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  SizedBox(height: 10,),
            
                  Text("Create new account",style: TextStyle(fontSize: 35, fontWeight: FontWeight.w300,color: Colors.blue[600])),
                  SizedBox(height: 30,),
                  
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                          return 'Input must required';
                        }
                      return null;

                    },
                    controller: username,
                    decoration: InputDecoration(
                        hintText: "masukan username",
                        labelText: 'enter your username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                     keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                          return 'Input must be at least 7 characters long';
                        }
                      return null;

                    },
                    controller: notlf,
                    decoration: InputDecoration(
                        labelText: 'enter your telofon number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                  SizedBox(height: 20,),
            
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                          return 'Input must be at least 8 characters long';
                        }
                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                      for (final user in listuser) {
                          if (email.text == user['email']) {
                            return "email already axist";                    
                          } 
                        }
                      return null;

                    },
                    controller: email,
                    decoration: InputDecoration(
                        labelText: 'enter your email',
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                  SizedBox(height: 20,),
            
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                          return 'Input must be at least 8 characters long';
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
                  SizedBox(height: 50,),
            
                  Container(
                    height: 50,
                    width: double.infinity,
                    
                    child: ElevatedButton(
                      onPressed: buttondisable ? null :  () {
                       createuser();
                       ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("succes sign'up")),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
            
                       style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.blue[600]),
                  
                    ),
                  ),
                  SizedBox(height: 40,),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("already have account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          "sign in here",
                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
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