import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storagetool/sqloperations.dart';

void main() {
  runApp(MaterialApp(
    home: Storagapp(),
  ));
}

class Storagapp extends StatefulWidget {
  const Storagapp({Key? key}) : super(key: key);

  @override
  State<Storagapp> createState() => _StoragappState();
}

class _StoragappState extends State<Storagapp> {
  bool isloading = true;
  List<Map<String, dynamic>> datas = [];

  void refreshdata() async {
    final data = await sqlhelper.getItemss();
    setState(() {
      datas = data;
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (datas != null) {
      refreshdata();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sqflite"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ShowForm(null),
        child: Icon(Icons.add),
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(datas[index]['title']),
                    subtitle: Text(datas[index]['description']),
                  ),
                );
              },
            ),
    );
  }

  final title_controller = TextEditingController();
  final description_conteroller = TextEditingController();

  void ShowForm(int? id) async {
    if (id != null) {
      final exiting_data = datas.firstWhere((element) => element[id == id]);
      title_controller.text = exiting_data["title"];
      description_conteroller.text = exiting_data["description"];
    }
    showBottomSheet(
      context: context,
      builder: (context) => Container(
        child: Column(
          children: [
            TextField(
              controller: title_controller,
              decoration: InputDecoration(hintText: "home"),
            ),
            TextField(
              controller: description_conteroller,
              decoration: InputDecoration(hintText: "discription"),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    //await additem();
                  } else {
                    //await update();
                  }
                  title_controller.clear();
                  description_conteroller.clear();
                  Navigator.pop(context);
                },
                child: Text(id == null ? "add Data" : "update")),
          ],
        ),
      ),
    );
  }

  Future<void> additems() async {
    await sqlhelper.add_items(
        title_controller.text, description_conteroller.text);
    refreshdata();
  }
}
