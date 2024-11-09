import "package:flutter/material.dart";
import "package:flutter_application_1/items.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({required this.user});
  final int user;

  @override
  State<HomePage> createState() => _HomePageState(user: user);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({required this.user});

  final int user;
  TextEditingController search = TextEditingController();
  List<Map<String, dynamic>> listData = [];
  List categorys = [];
  int? selectedCategoryId;
  var data = "";
  bool loading = true;

  Future<void> selectCategory(int categoryId) async {
    final response = await http.get(Uri.parse('http://192.168.1.6/wowitem/public/api/category/$categoryId'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      listData = List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load category data');
    }

    setState(() {
      selectedCategoryId = categoryId; // Update kategori yang dipilih
    });
  }

  Future<void> getData() async {
    final namaBrg = search.text;
    try {

        final responeCategory = await http.get(Uri.parse("http://192.168.1.6/wowitem/public/api/category"));
         if (responeCategory.statusCode == 200 ) {
            final datacategory = jsonDecode(responeCategory.body);
            setState(() {
              categorys = datacategory;
              loading = false;
            });
          } else {
            print("kook");
            throw Exception('Failed to load data');
          }

      if (namaBrg == "") {
        final response = await http.get(
            Uri.parse('http://192.168.1.6/wowitem/public/api/item'));
        if (response.statusCode == 200 ) {
          final data = jsonDecode(response.body);
          setState(() {
            listData = List<Map<String, dynamic>>.from(data);
            loading = false;
          });
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        final response = await http.get(Uri.parse(
            'http://192.168.1.6/wowitem/public/api/item?search=$namaBrg'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            listData = List<Map<String, dynamic>>.from(data);
            loading = false;
          });
        } else {
          throw Exception('Failed to load data');
        }
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
      backgroundColor: Colors.grey[100],
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Search section
                Container(
                  padding: EdgeInsets.all(20),
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg/bglogin.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo.png',
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        "WOWITEMS",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 27,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                              ),
                              height: 55,
                              child: Form(
                                child: TextFormField(
                                  controller: search,
                                  decoration: InputDecoration(
                                      hintText: "Search item here",
                                      hintStyle: TextStyle(color: Colors.blueGrey),
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none),
                                  onChanged: (text) {
                                    getData();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 55,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            child: Icon(Icons.search, color: Colors.blueGrey, size: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7),

                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // Categories section
                      SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      Container(
            margin: EdgeInsets.only(right: 10),
            height: 50,
            width: 100,
            child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: selectedCategoryId == 666 ? Colors.blue[200] : Colors.blue[500], // Ubah warna jika aktif
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  onPressed: () => selectCategory(666), // Kirim request saat diklik
                  child: Center(
                    child: Text(
                      "all",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
          ),
      Row(
        children: List.generate(categorys.length, (index) {
          return Container(
            margin: EdgeInsets.only(right: 10),
            height: 50,
            width: 100,
            child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: selectedCategoryId == categorys[index]['id_category'] ? Colors.blue[200] : Colors.blue[500], // Ubah warna jika aktif
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  onPressed: () => selectCategory(categorys[index]['id_category']), // Kirim request saat diklik
                  child: Center(
                    child: Text(
                      categorys[index]['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
          );
        }),
      ),
    ],
  ),
),  

                      SizedBox(height: 15),

                      // Items section
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: listData.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Item( listdata: {
                                                      'id_user': user,
                                                      'id_item': listData[index]
                                                          ['id_item'],
                                                      'name': listData[index]
                                                          ['name'],
                                                      'image': listData[index]
                                                          ['image'],
                                                      'stock': listData[index]
                                                          ['stock'],
                                                      'description': listData[index]
                                                          ['description']
                                                    })),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 5, color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                    ),
                                    height: 140,
                                    child: Image.network(
                                      'http://192.168.1.6/wowitem/public/api/imgitem/${listData[index]["image"]}',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        listData[index]['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      Text(
                                        "Stock: ${listData[index]['stock']}"  ,
                                        style: TextStyle(color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
