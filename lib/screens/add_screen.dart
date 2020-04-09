import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name, description;

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'name: ${doc.data['food_name']}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'todo: ${doc.data['food_description']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateData(doc),
                  child: Text('Update todo', style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'food name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return value;
      },
      onSaved: (value) => name = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            Form(
              key: _formKey,
              child: buildTextFormField(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: createData,
                  child: Text('Create', style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                RaisedButton(
                  onPressed: id != null ? readData : null,
                  child: Text('Read', style: TextStyle(color: Colors.white)),
                  color: Colors.blue,
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: db.collection('CRUD').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
                } else {
                  return SizedBox();
                }
              },
            )
          ],
        ),
      ),

    );
  }
  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('foods').add({'food_name': '$name 😎', 'food_description': '$description'});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('foods').document(id).get();
    print(snapshot.data['food_name']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db.collection('foods').document(doc.documentID).updateData({'food_description': '$description'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('foods').document(doc.documentID).delete();
    setState(() => id = null);
  }

}