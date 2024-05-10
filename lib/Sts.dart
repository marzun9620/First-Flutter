import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StsPage extends StatefulWidget {
  const StsPage({Key? key}) : super(key: key);

  @override
  State<StsPage> createState() => _StsPageState();
}

class _StsPageState extends State<StsPage> {
  TextEditingController wardNumberController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController coordinatesController = TextEditingController();
  TextEditingController collectionHourController = TextEditingController();
  TextEditingController fineRateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Firestore CRUD for STS"),
      ),
      body: StsList(),
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
                        "Ward Number: ",
                        textAlign: TextAlign.start,
                      ),
                    ),
                    TextField(
                      controller: wardNumberController,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Capacity (in tonnes): "),
                    ),
                    TextField(
                      controller: capacityController,
                      keyboardType: TextInputType.number,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Coordinates: "),
                    ),
                    TextField(
                      controller: coordinatesController,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Collection Hour: "),
                    ),
                    TextField(
                      controller: collectionHourController,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Fine Rate: "),
                    ),
                    TextField(
                      controller: fineRateController,
                      keyboardType: TextInputType.number,
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
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> newSts = {
                        "wardNumber": wardNumberController.text,
                        "capacityInTonnes":
                            double.parse(capacityController.text),
                        "coordinates": coordinatesController.text,
                        "collectionHour": collectionHourController.text,
                        "fineRate": double.parse(fineRateController.text),
                      };

                      FirebaseFirestore.instance
                          .collection("sts")
                          .add(newSts)
                          .then((value) {
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        print("Failed to add STS: $error");
                      });
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add STS',
        child: Icon(Icons.add),
      ),
    );
  }
}

class StsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('sts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return ListView(
              padding: EdgeInsets.only(bottom: 80),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Card(
                    child: ListTile(
                      title: Text("Ward Number: " + document['wardNumber']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Capacity (in tonnes): " +
                              document['capacityInTonnes'].toString()),
                          Text("Coordinates: " + document['coordinates']),
                          Text(
                              "Collection Hour: " + document['collectionHour']),
                          Text("Fine Rate: " + document['fineRate'].toString()),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditStsPage(
                                    documentId: document.id,
                                    initialWardNumber: document['wardNumber'],
                                    initialCapacity:
                                        document['capacityInTonnes'],
                                    initialCoordinates: document['coordinates'],
                                    initialCollectionHour:
                                        document['collectionHour'],
                                    initialFineRate: document['fineRate'],
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("sts")
                                  .doc(document.id)
                                  .delete()
                                  .catchError((error) {
                                print("Failed to delete STS: $error");
                              });
                            },
                          ),
                        ],
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

class EditStsPage extends StatefulWidget {
  final String documentId;
  final String initialWardNumber;
  final double initialCapacity;
  final String initialCoordinates;
  final String initialCollectionHour;
  final double initialFineRate;

  EditStsPage({
    required this.documentId,
    required this.initialWardNumber,
    required this.initialCapacity,
    required this.initialCoordinates,
    required this.initialCollectionHour,
    required this.initialFineRate,
  });

  @override
  _EditStsPageState createState() => _EditStsPageState();
}

class _EditStsPageState extends State<EditStsPage> {
  late TextEditingController wardNumberController;
  late TextEditingController capacityController;
  late TextEditingController coordinatesController;
  late TextEditingController collectionHourController;
  late TextEditingController fineRateController;

  @override
  void initState() {
    super.initState();
    wardNumberController =
        TextEditingController(text: widget.initialWardNumber);
    capacityController =
        TextEditingController(text: widget.initialCapacity.toString());
    coordinatesController =
        TextEditingController(text: widget.initialCoordinates);
    collectionHourController =
        TextEditingController(text: widget.initialCollectionHour);
    fineRateController =
        TextEditingController(text: widget.initialFineRate.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit STS"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: wardNumberController,
              decoration: InputDecoration(labelText: 'Ward Number'),
            ),
            TextField(
              controller: capacityController,
              decoration: InputDecoration(labelText: 'Capacity (in tonnes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: coordinatesController,
              decoration: InputDecoration(labelText: 'Coordinates'),
            ),
            TextField(
              controller: collectionHourController,
              decoration: InputDecoration(labelText: 'Collection Hour'),
            ),
            TextField(
              controller: fineRateController,
              decoration: InputDecoration(labelText: 'Fine Rate'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> updatedData = {
                  "wardNumber": wardNumberController.text,
                  "capacityInTonnes": double.parse(capacityController.text),
                  "coordinates": coordinatesController.text,
                  "collectionHour": collectionHourController.text,
                  "fineRate": double.parse(fineRateController.text),
                };

                FirebaseFirestore.instance
                    .collection("sts")
                    .doc(widget.documentId)
                    .update(updatedData)
                    .then((value) {
                  Navigator.pop(context);
                }).catchError((error) {
                  print("Failed to update STS: $error");
                });
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
