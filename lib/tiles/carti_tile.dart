import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      CartModel.of(context).updatePrices();

      return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProduct.productdata.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    cartProduct.productdata.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    "Tamanho ${cartProduct.size}",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "R\$ ${cartProduct.productdata.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed:cartProduct.quantity > 1 ?(){
                          CartModel.of(context).decProduct(cartProduct);
                        } : null
                      ),
                      Text(
                        cartProduct.quantity.toString(),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed:(){
                          CartModel.of(context).incProduct(cartProduct);
                        } ,
                      ),
                      FlatButton(
                        child: Text(
                          "Remover",
                        ),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CartModel.of(context).removeCartItem(cartProduct);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productdata == null ?
          FutureBuilder<DocumentSnapshot>(
            future: Firestore.instance.collection("products").document(cartProduct.category)
                .collection("items").document(cartProduct.pid).get(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                cartProduct.productdata = ProductData.fromDocument(snapshot.data);
                return _buildContent();
              } else{
                return Container(
                  height: 70.0,
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              }
            },
          ) :
          _buildContent()
    );
  }
}
