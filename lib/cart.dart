import 'package:flutter/material.dart';
import 'package:flutter_application_1/items.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// beres@gmail.com
class Cart extends StatefulWidget {
   Cart({required this.id_user, });
  final int id_user;
  @override
  State<Cart> createState() => _CartState(id_user: id_user);
}

class _CartState extends State<Cart> {
  _CartState({required this.id_user});
  final int id_user;
  List listData = [];
  bool loading = true;

Future delete(int id_cart) async{
    try { 
      final response = await http
          .delete(Uri.parse("http://192.168.1.6/wowitem/public/api/cart/delete/${id_cart}"),);

      if (response.statusCode == 200) {
        return  Navigator.pop(context);
      }
    } catch (e) {}
  }
 

  Future getData() async {

    try {
        final response = await http.get(Uri.parse(
            'http://192.168.1.6/wowitem/public/api/cart/$id_user'));
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Row(children: [
          Icon(Icons.trolley),
            SizedBox(width: 5,),
          Text(
                  "cart",
                  style: TextStyle(color: Colors.blueGrey,
                  fontWeight: FontWeight.w500, 
                  fontSize: 24
                  ),
                ),
          ],),
      ),
      backgroundColor: Colors.grey[100],
      body: 
        loading
          ? Center(child: CircularProgressIndicator())
          :Container(
      child: listData.isEmpty ? Center(
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
                  width: 50,
                  height: 300,
                  child: Image.network("http://192.168.1.6/wowitem/public/api/imgitem/${listData[index]['item']['image']}")),
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
                        "stock: ${listData[index]['item']['stock']}",
                        style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                        
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                           Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Item( listdata: {
                                                      'id_user': id_user,
                                                      'id_item': listData[index]
                                                          ['item']['id_item'],
                                                      'name': listData[index]
                                                          ['item']['name'],
                                                      'image': listData[index]
                                                          ['item']['image'],
                                                      'stock': listData[index]
                                                          ['item']['stock'],
                                                      'description': listData[index]
                                                          ['item']['description']
                                                    })),
                              );
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue[400])),
                          child: Text("view")), 
                         SizedBox(width: 10,), 
                         ElevatedButton(
                          onPressed: () {
                           delete(listData[index]["id"]);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.red[400])),
                          child: Text("delete")), 

                         
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    ),
    );
  }
}

