import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData{

  String category;

  String id;
  String title;
  String description;
  double price;
  List images;
  List sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["Title"];
    description = snapshot.data["Description"];
    price = snapshot.data["Preço"] + 0.0;
    images = snapshot.data["Images"];
    sizes = snapshot.data["Sizes"];
  }

  Map<String, dynamic> toResumedMap(){
    return{
      "title": title,
      "description": description,
      "preço": price,
    };
  }

}