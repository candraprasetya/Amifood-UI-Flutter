import 'package:cloud_firestore/cloud_firestore.dart';

final databaseReference = Firestore.instance;

class Record {
  String name, image, description;
  int price, order;
  bool ordered;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['food_name'] != null),
        assert(map['food_image'] != null),
        assert(map['food_price'] != null),
        assert(map['food_order'] != null),
        assert(map['food_ordered'] != null),
        name = map['food_name'],
        image = map['food_image'],
        description = map['food_description'],
        order = map['food_order'],
        price = map['food_price'],
        ordered = map['food_ordered'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$price:$image:$description:$order;$ordered>";
}
