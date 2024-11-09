import 'package:flutter/material.dart';
import 'package:flutter_application_1/statusborrow.dart';
import 'package:flutter_application_1/statusreturn.dart';

class Borrowing extends StatelessWidget {
   Borrowing({required this.user});
  final int user;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TabBar(
            labelColor: Colors.blue, // Warna teks untuk tab yang aktif
            unselectedLabelColor: Colors.blueGrey,
            tabs: <Widget>[
              Tab(
                text: "proses borrow",
              ),
              Tab(
                text: "borrowed ",
              ),
              Tab(
                text: "proses return",
              ),
              Tab(
                text: "returned",
              ),
            ],
          ),
        ),
        body:  TabBarView(
          children: <Widget>[
            Status(id_user: user, status: "pending"),
            Status(id_user: user, status: "borrowing"),
            StatusReturn(id_user: user, status: "pending"),
            StatusReturn(id_user: user, status: "returned")
          ],
        ),
      ),
    );
  }
}
