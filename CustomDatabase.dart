import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CustomData extends StatefulWidget {
  CustomData({this.app});
  final FirebaseApp app;
  @override
  _CustomDataState createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  final referenceDatabase = FirebaseDatabase.instance;
  final product = 'prodTitle';
  final prodController = TextEditingController();

  DatabaseReference _prodRef;
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _prodRef = database.reference().child("product");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Database"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  color: Colors.orange,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Text(
                        product,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: prodController,
                        textAlign: TextAlign.center,
                      ),
                      FlatButton(
                        color: Colors.deepOrange,
                        onPressed: () {
                          ref
                              .child('product')
                              .push()
                              .child(product)
                              .set(prodController.text)
                              .asStream();
                          prodController.clear();
                        },
                        child: Text(
                          "Save Product",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Flexible(
                          child: new FirebaseAnimatedList(
                              shrinkWrap: true,
                              query: _prodRef,
                              itemBuilder: (BuildContext context,
                                  DataSnapshot snapshot,
                                  Animation<double> animation,
                                  int index) {
                                return new ListTile(
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        _prodRef.child(snapshot.key).remove(),
                                  ),
                                  title: new Text(snapshot.value["prodTitle"]),
                                );
                              })),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
