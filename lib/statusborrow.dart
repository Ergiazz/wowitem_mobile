import 'package:flutter/material.dart';
import 'package:flutter_application_1/taskbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// beres@gmail.com
class Status extends StatefulWidget {
   Status({required this.id_user, required this.status});
  final int id_user;
  final String status;



  @override
  State<Status> createState() => _StatusState(id_user: id_user, status: status);
}

class _StatusState extends State<Status> {
  _StatusState({required this.id_user,required this.status});
  final int id_user;
  final String status;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
  try {
    print("Opening gallery...");
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path.toString());
        print("Image selected: ${image.path}");
      });
    } else {
      print("No image selected");
    }
  } catch (e) {
    print("Error: $e");
  }
  }




  TextEditingController search = TextEditingController();
  List listData = [];
  bool loading = true;
  int pending = 0;

  Future<void> requestReturn(Map itemData) async {
    try {
      // Buat request Multipart
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("http://192.168.1.6/wowitem/public/api/pengembalian"),
      );

      // Tambahkan data sebagai fields
      request.fields['id_user'] = id_user.toString();
      request.fields['id_item'] = itemData["item"]["id_item"].toString();
      request.fields['id_peminjaman'] = itemData["id_peminjaman"].toString();

      // Tambahkan gambar jika ada
      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'bukti_img', 
            _selectedImage!.path,
          ),
        );
      }

      // Kirim request
      final response = await request.send();

      // Cek status response
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print("Request berhasil: $responseData");

        // Pindah ke halaman baru jika berhasil
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationBarApp(iduser: id_user),
          ),
        );
      } else {
        print("Request gagal dengan status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  

  Future getData() async {

    try {
        final response = await http.get(Uri.parse(
            'http://192.168.1.6/wowitem/public/api/pinjaman/$id_user?status=$status'));
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

  

   void _showInfoDialog(Map itemData) {
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
                      image: NetworkImage(
                          "http://192.168.1.6/wowitem/public/api/imgitem/${itemData['item']['image']}"),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  itemData['item']['name'],
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  itemData['item']['description'],
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
                Text(
                  "Jumlah: ${itemData['jumlah']}",
                  style: TextStyle(color: Colors.grey[500], fontSize: 15),
                ),
                Text(
                  "Borrowing Date: ${itemData['tgl_pinjam']}",
                  style: TextStyle(color: Colors.grey[500], fontSize: 15),
                ),
                Text(
                  "Returned Date: ${itemData['tgl_kembali']}",
                  style: TextStyle(color: Colors.grey[500], fontSize: 15),
                ),
                Text(
                  "Returned Time: ${itemData['jam_kembali']}",
                  style: TextStyle(color: Colors.grey[500], fontSize: 15),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

   void _showFormDialog(Map itemData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("is done ??"),
          content: Container(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Are you sure to mark this item as done?",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
               Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImageFromGallery,
            child: Text("Pick Image from Gallery"),
          ),

        ],
      ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                requestReturn(itemData);
                return Navigator.of(context).pop(); 

              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
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
                    "you does not borrow item",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                    ],
                  )
                )
              :ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: listData.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 20, 10),
              leading: Container(
                  width: 60,
                  height: 140,
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
                        "quantity: ${listData[index]['jumlah']}",
                        style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                        
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                           
                              _showInfoDialog(listData[index]);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue[400])),
                          child: Icon(Icons.info)), 
                         SizedBox(width: 10,), 

                         if(status == "borrowing") 
                          ElevatedButton(
                          onPressed: () {
                            _showFormDialog(listData[index]);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green[400])),
                          child: Text("is done")),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
