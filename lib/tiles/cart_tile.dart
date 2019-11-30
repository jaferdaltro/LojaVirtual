import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/model/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;


  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
                cartProduct.productData.images[0], fit: BoxFit.cover),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    cartProduct.productData.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "Tamanho ${cartProduct.size}",
                    style: TextStyle(
                        fontWeight: FontWeight.w300
                    ),
                  ),
                  Text(
                    "R\$ ${cartProduct.productData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove), color: Theme.of(context).primaryColor,
                        onPressed: cartProduct.quantity > 1 ?
                            (){
                              CartModel.of(context).decProduct(cartProduct);
                            }
                            : null,
                      ),
                      Text(
                        cartProduct.quantity.toString()
                      ),
                      IconButton(
                          icon: Icon(Icons.add), color: Theme.of(context).primaryColor,
                          onPressed: (){
                            CartModel.of(context).incProduct(cartProduct);
                          },
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CartModel.of(context).removeCartItem(cartProduct);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Column()
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: cartProduct.productData == null
          ? /*caso esteja sem produto, buscar no servidor*/
      FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection("products").
        document(cartProduct.category).collection("items").
        document(cartProduct.pid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            cartProduct.productData = ProductData.fromData(snapshot.data);
            return _buildContent();
          } else {
            return Container(
              height: 70.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      )
          : _buildContent(), /*caso tenha produto */
    );
  }
}
