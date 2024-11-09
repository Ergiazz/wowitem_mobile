import 'package:flutter/material.dart';
import 'package:flutter_application_1/taskbar.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert';

class Item extends StatefulWidget {
  final Map listdata;

  const Item({required this.listdata});


  @override
  
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  int _counter = 1;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  int iditem = 0;
  int iduser = 0;
  String name = "";
  String image = "";
  int stock = 0;
  String description = "";
  DateTime todayDateOnly =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void _increment() {
    setState(() {
      if (_counter < widget.listdata['stock']) _counter++;
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 1) _counter--; // Mencegah angka negatif
    });
  }

   Future cart() async{
    try { 
      final response = await http
          .post(Uri.parse("http://192.168.1.6/wowitem/public/api/cart"),
          body: {
            'id_user': iduser.toString(),
            'id_item': iditem.toString(),
          }
          );

      if (response.statusCode == 200) {
        return  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("succes added to cart")),
      );
      }
    } catch (e) {}
  }

  void showDate() async{
    DateTime? date = await showDatePicker(
            context: context,
            initialDate: todayDateOnly,
            firstDate: todayDateOnly,
            lastDate: todayDateOnly.add(Duration(days: 7)));
    if (date != null) {
      setState(() {
        selectedDate = date;
        print(selectedDate);
      });
    }

  }

  void showtime() async{
     TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
       if (time.hour >= 6 && time.hour <= 17) {
      setState(() {
        selectedTime = time;
      });
    } else {
      // Jika waktu di luar rentang, tampilkan pesan dan reset
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a time between 06:00 and 17:00")),
      );
    }
    }
  }

  Future<void> submitData() async {
    if (selectedDate == null || selectedTime == null) {
      // Tampilkan pesan error jika tanggal atau waktu belum dipilih
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both date and time")),
      );
      return;
    }

    final String formattedDate = "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";
    final String formattedTime = "${selectedTime!.hour}:${selectedTime!.minute}";
     print(iduser);
     print(iditem);
     print(formattedDate);
     print(formattedTime);
     print(_counter);

    final url = Uri.parse('http://192.168.1.6/wowitem/public/api/pinjam');
    final response = await http.post(url, body: {
      'id_user': iduser.toString(),
      'id_item': iditem.toString(),
      'tgl_kembali': formattedDate,
      'jam_kembali': formattedTime,
      'jumlah': _counter.toString(),
    });

    if (response.statusCode == 200) {
      // Tampilkan pesan sukses atau navigasi ke halaman lain
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item borrowed successfully!")),
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NavigationBarApp(iduser: iduser)));
    } else {
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to borrow item")),
      );
    }
  }
  
   void initState() {
    super.initState();
    iduser = widget.listdata['id_user'];
    iditem = widget.listdata['id_item'];
  name = widget.listdata['name'] ;
  image = widget.listdata['image'];
  stock = widget.listdata['stock'];
  description = widget.listdata['description'];




  }

  @override
  
  Widget build(BuildContext context) {
    print(name);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: NetworkImage(
                                      'http://192.168.1.6/wowitem/public/api/imgitem/${image}',
                                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            //info
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(
                "${name}",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    cart();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shadowColor: Colors.blue),
                  child: Icon(
                    Icons.trolley,
                    color: Colors.white,
                  )),
            ],
            
            ),
            
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.category, color: Colors.green, size: 20),
                const SizedBox(width: 5),
                Text("electronic", style: TextStyle(color: Colors.black54)),
                const SizedBox(width: 15),
                Icon(Icons.card_travel, color: Colors.blue, size: 20),
                const SizedBox(width: 5),
                Text("${stock} stock", style: TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${description}",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.library_books, color: Colors.grey),
                    const SizedBox(height: 5),
                    Text("dont late", style: TextStyle(color: Colors.black54)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey),
                    const SizedBox(height: 5),
                    Text("max 7 Days", style: TextStyle(color: Colors.black54)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.health_and_safety_outlined, color: Colors.grey),
                    const SizedBox(height: 5),
                    Text("take care", style: TextStyle(color: Colors.black54)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.grey),
                    const SizedBox(height: 5),
                    Text("use smartly",
                        style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "borrow now",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: ElevatedButton(
                        onPressed: () {
                          showDate();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shadowColor: Colors.blue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.date_range,
                              color: Colors.white,
                            ),
                            Text(
                              " returned date",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    width: 170,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: ElevatedButton(
                        onPressed: () {
                          showtime();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shadowColor: Colors.blue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_clock,
                              color: Colors.white,
                            ),
                            Text(
                              " returned time",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
                ],

                
              ),
            ),
            
            // button
            const Spacer(),
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tombol "-"
                        IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: _decrement,
                        ),
                        // Kotak angka
                        Container(
                          height: double.infinity,
                          width: 50,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Text(
                            '$_counter',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        // Tombol "+"
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: _increment,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    
                    child: ElevatedButton(
                       
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: submitData,
                      child: Text(
                        "borrow now",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
