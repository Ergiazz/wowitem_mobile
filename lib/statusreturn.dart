import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// beres@gmail.com
class StatusReturn extends StatefulWidget {
   StatusReturn({required this.id_user, required this.status});
  final int id_user;
  final String status;


  @override
  State<StatusReturn> createState() => _StatusRState(id_user: id_user, status: status);
}

class _StatusRState extends State<StatusReturn> {
  _StatusRState({required this.id_user,required this.status});
  final int id_user;
  final String status;
  TextEditingController search = TextEditingController();
  List listData = [];
  bool loading = true;
  int pending = 0;

  Future getData() async {

    try {
        final response = await http.get(Uri.parse(
            'http://192.168.1.6/wowitem/public/api/pengembalian/$id_user?status=$status'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            listData = data;
            loading = false;
            
          });
        } else {
          throw Exception('Failed to load data');
        }
      
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return loading
          ? Center(child: CircularProgressIndicator())
          :Container(
      child: listData.isEmpty
              ? Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon( Icons.dangerous_outlined, size: 100,color: Colors.blueGrey,),
                       Text(
                    "you does not returned item",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                    ],
                  )
                ) : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: listData.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 20, 10),
              leading: Container(
                  width: 60,
                  child: Image.network("http://192.168.1.6/wowitem/public/api/bukti_img/${listData[index]['bukti_img']}")),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                                    listData[index]['item']['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey),
                                  ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "quantity: ${listData[index]['peminjaman']['jumlah']}",
                        style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                        
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                  height: 330,
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      Container(
                                        width: double.infinity,
                                        height: 170,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            image: DecorationImage(
                                              image: NetworkImage("http://192.168.1.6/wowitem/public/api/bukti_img/${listData[index]['bukti_img']}"),
                                            )
                                            ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        listData[index]['item']['name'] ,
                                        style: TextStyle(
                                          color: Colors.blue[600],
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      
                                      Text(
                                        listData[index]['item']['description'],
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 13,
                                          )),
                                      Text("quantity: ${listData[index]['peminjaman']['jumlah']}",
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 15,
                                          )
                                        ),
                                        Text("borrowing date: ${listData[index]['peminjaman']['tgl_pinjam']}",
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 15,
                                          )
                                        ),
                                        Text("returned date: ${listData[index]['craeted_at']}",
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 15,
                                          ),
                                        ),
                                      
                                      
                                    ],
                                  )),
                            );
                          },
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue[400])),
                      child: Icon(Icons.info))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
