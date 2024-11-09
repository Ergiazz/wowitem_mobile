import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/register.dart';


class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
      home: Scaffold(
        
        backgroundColor: Colors.blue.shade700,
        
        body: ListView(
          padding: EdgeInsets.only(top: 90),
          children: [
            
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                color: Colors.white
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/icon.png"),
                    
                  ),
                  DefaultTextStyle(
                    style: TextStyle(color: Colors.blueGrey),
                    child: Column(
                        children: [
                          Text("WELLCOME TO",style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, ),),
                          Text("WOWITEM APP FOR BORROW ",style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25,color: Colors.blueGrey),),
                          Text("Find any items you need, anywhere and anytime."),
                        ],
                  )),

                  Container(
                    height: 350,
                    child: Image.asset("assets/peminjaman.png"),
                  ),
                    
                    
            
                    Container(
                      height: 50,
                      margin:EdgeInsets.all(20),
                      decoration: BoxDecoration(
                      ),
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                        },
                        style: ElevatedButton.styleFrom(
                        minimumSize: Size(400, 35),
                         backgroundColor: Colors.blue[600]
                          
                         ),
                       child: Center(
                        child: Text("Sign'in"),
                      )
                      ),
                    ),
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("you dont have account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        "sign up here",
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
