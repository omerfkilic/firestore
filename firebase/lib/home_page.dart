// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/toplama.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference moviesRef = _firestore.collection('movies');
    var babaRef = moviesRef.doc('The Godfather');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firestore Database'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${babaRef.id}',
                style: TextStyle(fontSize: 24),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var response = await babaRef.get();
                    var data = response.data();
                    print((data as Map)['name']);
                    print((data as Map)['year']);
                    print((data as Map)['rating']);
                  },
                  child: Text('get data')),
              ElevatedButton(
                  onPressed: () async {
                    var response = await moviesRef.get();
                    var list = response.docs;
                    print(list[2].data());
                  },
                  child: Text('get querysnapshot')),
              StreamBuilder<DocumentSnapshot>(
                stream: babaRef.snapshots(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    return Text(asyncSnapshot.data!.data().toString());
                  } else {
                    return Center();
                  }
                },
              ),
              /////////////////////////////////////////////////
              StreamBuilder<QuerySnapshot>(
                stream: moviesRef.snapshots(),
                builder: (context, asyncSnapshot) {
                  List<DocumentSnapshot> listOfDocumentSnap;
                  if (asyncSnapshot.hasData) {
                    listOfDocumentSnap = asyncSnapshot.data?.docs ?? [];
                    return Flexible(
                      child: ListView.builder(
                        itemCount: listOfDocumentSnap.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text((listOfDocumentSnap[index].data()
                                  as Map)['name']),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text((listOfDocumentSnap[index].data()
                                          as Map)['year']
                                      .toString()),
                                  Text((listOfDocumentSnap[index].data()
                                          as Map)['rating']
                                      .toString()),
                                ],
                              ),
                              trailing: IconButton(
                                  onPressed: () async {
                                    await listOfDocumentSnap[index]
                                        .reference
                                        .delete();
                                  },
                                  icon: Icon(Icons.delete)),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
