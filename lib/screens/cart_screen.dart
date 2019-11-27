import 'package:flutter/material.dart';
import 'package:loja_virtual/model/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        actions: <Widget>[
          ScopedModelDescendant<CartModel>(
            builder: (context, child, model){
              int p = model.products.length;
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                      "${p ?? 0} ${p == 1 ? "ITEM": "ITENS"}",
                    style: TextStyle(fontSize: 17.0),
                  )
              );
            },
          )
        ],
      ),
    );
  }
}
