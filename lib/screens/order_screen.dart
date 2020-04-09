import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/item_model.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('foods')
          .where('food_ordered', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return RefreshProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    bool ordered = record.ordered;

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
            ),
          ],
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              width: MediaQuery.of(context).size.width,
              height: 140.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(record.image))),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(record.name,
                        style: TextStyle(fontFamily: 'Montserrat-Medium')),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(record.description),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Rp. ' + record.price.toString(),
                              style: TextStyle(
                                  fontFamily: 'Montserrat-Regular',
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () {
                                  int banyak = record.order;
                                  banyak--;
                                  if (banyak <= 0) {
                                    banyak = 0;
                                    ordered = false;
                                  }
                                  setState(() async {
                                    await Firestore.instance
                                        .collection('foods')
                                        .document(data.documentID)
                                        .updateData({
                                      'food_order': banyak,
                                      'food_ordered': ordered
                                    });
                                  });
                                },
                                child: new Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                                shape: new CircleBorder(),
                                elevation: 0.1,
                                fillColor: Colors.purple,
                              ),
                              Text(record.order.toString()),
                              RawMaterialButton(
                                onPressed: () {
                                  int banyak = record.order;
                                  banyak++;
                                  setState(() async {
                                    await Firestore.instance
                                        .collection('foods')
                                        .document(data.documentID)
                                        .updateData({'food_order': banyak});
                                  });
                                },
                                child: new Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                                shape: new CircleBorder(),
                                elevation: 0.1,
                                fillColor: Colors.purple,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    padding: EdgeInsets.only(left: 10.0, top: 16.0, bottom: 14.0),
                    child: Text(
                      'Your Orders',
                      style: TextStyle(fontSize: 24.0, color: Colors.purple),
                    )
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: AnimatedContainer(
                  curve: Curves.elasticIn,
                  duration: Duration(milliseconds: 1000),
                  child: _buildBody(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
