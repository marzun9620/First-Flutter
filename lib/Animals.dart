import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Firestore CRUD"),
      ),
      body: BookList(),
      // ADD (Create)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Add"),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Title: ",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      TextField(
                        controller: titleController,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("Author: "),
                      ),
                      TextField(
                        controller: authorController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Undo",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    //Add Button

                    ElevatedButton(
                      onPressed: () {
                        //TODO: Firestore create a new record code

                        Map<String, dynamic> newBook =
                            new Map<String, dynamic>();
                        newBook["title"] = titleController.text;
                        newBook["author"] = authorController.text;

                        FirebaseFirestore.instance
                            .collection("books")
                            .add(newBook)
                            .then((value) {
                          Navigator.of(context).pop();
                        }).catchError((error) {
                          print("Failed to add book: $error");
                        });
                      },
                      child: Text(
                        "save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              });
        },
        tooltip: 'Add Title',
        child: Icon(Icons.add),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController authorController = TextEditingController();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('books').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return ListView(
              padding: EdgeInsets.only(bottom: 80),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                titleController.text = document['title'];
                authorController.text = document['author'];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Update Dialog"),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Title: ", textAlign: TextAlign.start),
                                  TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      hintText: document['title'],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text("Author: "),
                                  ),
                                  TextField(
                                    controller: authorController,
                                    decoration: InputDecoration(
                                      hintText: document['author'],
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Undo",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Update Firestore record information regular way
                                    FirebaseFirestore.instance
                                        .collection("books")
                                        .doc(document.id)
                                        .update({
                                      "title": titleController.text,
                                      "author": authorController.text,
                                    }).then((value) {
                                      Navigator.of(context).pop();
                                    }).catchError((error) {
                                      print("Failed to update book: $error");
                                    });

                                    // Update Firestore record information using a transaction to prevent any conflict in data changed from different sources
                                    /*FirebaseFirestore.instance.runTransaction((transaction) async {
                                      await transaction.update(document.reference, {
                                        'title': titleController.text,
                                        'author': authorController.text,
                                      }).then((value) {
                                        Navigator.of(context).pop();
                                      }).catchError((error) {
                                        print("Failed to update book: $error");
                                      });
                                    });*/
                                  },
                                  child: Text("Update",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      title: Text("Title " + document['title']),
                      subtitle: Text("Author " + document['author']),
                      trailing: InkWell(
                        onTap: () {
                          // Delete Firestore record
                          FirebaseFirestore.instance
                              .collection("books")
                              .doc(document.id)
                              .delete()
                              .catchError((error) {
                            print("Failed to delete book: $error");
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
