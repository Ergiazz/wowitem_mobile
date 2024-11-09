import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  Profile({required this.user});
  final int user;

  @override
  State<Profile> createState() => _ProfileState(user: user);
}

class _ProfileState extends State<Profile> {
  _ProfileState({required this.user});
  final int user;

  List listData = [];
  Map<String, dynamic> infouser = {};
  bool loading = true;
  int pending = 0;
  int borrowing = 0;
  int returned = 0;
  int total = 0;


  Future finduser() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.6/wowitem/public/api/user/$user'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          listData = data[1];
          infouser = data[0];
          loading = false;
          pending = jumlahpinjaman("pending");
          borrowing = jumlahpinjaman("borrowing");
          returned = jumlahpinjaman("returned");
          
        });
      } else {
        print('Failed to load user data: ${response.statusCode}');
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        loading = false;
      });
    }
  } 

  jumlahpinjaman(String status){
    total = 0;
    for(final data in listData ){
        if(data['status'] == status){
         total++;
        }
    }
    return total;
  }
  

  @override
  void initState() {
    super.initState();
    finduser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loading
          ? Center(child: CircularProgressIndicator())
          :Scaffold(
        backgroundColor: Colors.blue[500],
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[500],
                  image: DecorationImage(
                    image: AssetImage("assets/bg/profile.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.all(30),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Color.fromARGB(255, 231, 227, 227),
                      backgroundImage: AssetImage("assets/profile.jpg"),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              infouser["name"],
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 23,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              infouser["email"] ,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                height: 560,
                margin: EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(vertical: 13),
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Total Pending",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${pending}",
                                  style: TextStyle(color: Colors.blue, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(vertical: 13),
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Total Borrowing",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${borrowing}",
                                  style: TextStyle(color: Colors.blue, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(vertical: 13),
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Total Returned",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${returned}",
                                  style: TextStyle(color: Colors.blue, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.blue[500],
                          ),
                          SizedBox(width: 10),
                          Text(
                            "username: ${infouser["name"]}", 
                            style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mail,
                            size: 30,
                            color: Colors.blue[500],
                          ),
                          SizedBox(width: 10),
                          Text(
                            "email: ${infouser["email"]}", 
                            style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
