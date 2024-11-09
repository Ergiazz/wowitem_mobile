import 'package:flutter/material.dart';
import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/dashboard.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/borrowing.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/profile.dart';

class NavigationBarApp extends StatelessWidget {
    final int iduser;
    NavigationBarApp({required this.iduser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.blueGrey,
      elevation: 0,
    ),
      ),
      home:  NavigationExample(user: iduser),
    );
  }
}

class NavigationExample extends StatefulWidget {
  final int user;
    NavigationExample({required this.user});

  @override
  State<NavigationExample> createState() => _NavigationExampleState(user: user);
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
    final int user;
    _NavigationExampleState({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          title:  Row(children: [
            Image.asset("assets/logo.png", width: 25,),
            SizedBox(width: 5,),
          Text(
                  "WOWITEMS",
                  style: TextStyle(color: Colors.blue[600],
                  fontWeight: FontWeight.w700, 
                  fontSize: 18
                  ),
                ),
          ],)
              
        ),
        endDrawer: Drawer(
          backgroundColor: Colors.white,
          
          
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text(""),
                accountEmail: Text(""),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 26, 25, 25),
                    image: DecorationImage(
                        image: AssetImage("assets/icon.png"),
                        fit: BoxFit.cover)),
              ),

              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.home_outlined, color: Colors.blueGrey,),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Dashboard", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey),)
                  ],
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => dashboard()));
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.trolley, color: Colors.blueGrey,),
                    SizedBox(
                      width: 5,
                    ),
                    Text("cart", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey),)
                  ],
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cart(id_user: user)));
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.login,
                    color: Colors.blueGrey,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Log out",style: TextStyle(color: Colors.blueGrey,),)
                  ],
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
          ),
        ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue[400],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.blueGrey),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined, color: Colors.blueGrey),
            selectedIcon: Icon(Icons.note_alt, color: Colors.white),

            label: 'borrowing',
          ),
           NavigationDestination(
            icon: Icon(Icons.person_2_outlined, color: Colors.blueGrey),
            selectedIcon: Icon(Icons.person_2, color: Colors.white),

            label: 'About',
          ),
          
        ],
      ),
      body: <Widget>[
        HomePage(user: user),

        Borrowing(user: user),

        Profile(user: user)


      ][currentPageIndex],
    );
  }
}
