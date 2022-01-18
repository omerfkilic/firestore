import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Toplama extends StatefulWidget {
  const Toplama({Key? key}) : super(key: key);

  @override
  _ToplamaState createState() => _ToplamaState();
}

class _ToplamaState extends State<Toplama> {
  final _firestore = FirebaseFirestore.instance;
  int total = 0;
  @override
  Widget build(BuildContext context) {
    CollectionReference examRef = _firestore.collection('exam');
    Random rng = new Random();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firestore Database'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /////////////////////////////////////////////////
              StreamBuilder<QuerySnapshot>(
                stream: examRef.snapshots(),
                builder: (context, asyncSnapshot) {
                  List<DocumentSnapshot> listOfDocumentSnap;
                  if (asyncSnapshot.hasData) {
                    listOfDocumentSnap = asyncSnapshot.data?.docs ?? [];
                    total = 0;
                    return Flexible(
                      child: ListView.builder(
                        itemCount: listOfDocumentSnap.length,
                        itemBuilder: (context, index) {
                          calculateTotal(
                              (listOfDocumentSnap[index].data() as Map)['num']);

                          return Card(
                            child: ListTile(
                              title: Text((listOfDocumentSnap[index].data()
                                      as Map)['num']
                                  .toString()),
                              trailing: IconButton(
                                  onPressed: () async {
                                    calculateTotal(((listOfDocumentSnap[index]
                                            .data() as Map)['num'] *
                                        -1));
                                    await listOfDocumentSnap[index]
                                        .reference
                                        .delete();
                                    setState(() {});
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
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Toplam',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(total.toString(), style: TextStyle(fontSize: 24))
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await examRef.add({'num': rng.nextInt(100)});
                    setState(() {});
                  },
                  child: Text('random sayı oluştur'))
            ],
          ),
        ),
      ),
    );
  }

  void calculateTotal(int num) {
    total = total + num;
  }
}
