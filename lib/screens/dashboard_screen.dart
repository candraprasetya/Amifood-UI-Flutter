import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/item_model.dart';
import 'add_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String iconMenu = 'assets/icons/icMenu.svg';

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              'amifood',
              style: TextStyle(
                fontFamily: 'Montserrat-Medium',
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
              ),
            ),
            Text(
              'eat some food now!',
              style:
              TextStyle(fontSize: 10.0, fontFamily: 'Montserrat-Regular'),
            )
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddItemScreen()));
          },
          child: SvgPicture.asset(
            iconMenu,
            color: Colors.blueGrey,
          ),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('foods').snapshots(),
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
    bool checkOrder = record.ordered;

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
                                  color: Colors.purple[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                          checkOrder
                              ? CupertinoButton.filled(
                            onPressed: () {
                              checkOrder = false;
                              setState(() async {
                                await Firestore.instance
                                    .collection('foods')
                                    .document(data.documentID)
                                    .updateData({
                                  'food_ordered': checkOrder,
                                  'food_order': 0
                                });
                              });
                            },
                            child: Text('ORDERED'),
                          )
                              : CupertinoButton.filled(
                            onPressed: () {
                              checkOrder = true;
                              int order = record.order;
                              order++;
                              setState(() async {
                                await Firestore.instance
                                    .collection('foods')
                                    .document(data.documentID)
                                    .updateData({
                                  'food_ordered': checkOrder,
                                  'food_order': order
                                });
                              });
                            },
                            child: Text('ORDER'),
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

  Widget _buildHello() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Hi Candra!',
            style: TextStyle(fontFamily: 'Montserrat-Regular'),
          )),
    );
  }

  Widget _buildAmipay() {
    var saldoAmipay = 10000;

    return AnimatedContainer(
      curve: Curves.bounceIn,
      duration: Duration(milliseconds: 1000),
      height: MediaQuery.of(context).size.height / 14,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.purple[400]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              'assets/images/amipaylogo.png',
            ),
            Text('Rp. $saldoAmipay',
                style: TextStyle(
                    fontFamily: 'Montserrat-Medium',
                    fontSize: 16.0,
                    color: Colors.white)),
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
              _buildTitle(),
              _buildHello(),
              _buildAmipay(),
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 1000),
                  padding: EdgeInsets.only(left: 10.0, top: 16.0, bottom: 14.0),
                  child: Text(
                    'need some food ?',
                    style: TextStyle(fontSize: 24.0, color: Colors.black45),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: AnimatedContainer(
                  curve: Curves.bounceIn,
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
