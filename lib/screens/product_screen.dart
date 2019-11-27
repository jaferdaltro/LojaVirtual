import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/model/cart_model.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData data;

  ProductScreen(this.data);

  @override
  _ProductScreenState createState() => _ProductScreenState(data);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData data;
  String size;

  _ProductScreenState(this.data);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
        appBar: AppBar(
          title: Text(data.title),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.9,
              child: Carousel(
                images: data.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                  ),
                  Text(
                    "R\$ ${data.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Tamanho",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 34.0,
                    child: GridView(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.5,
                      ),
                      children: data.sizes?.map((s) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  size = s;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  border: Border.all(
                                    color: size == s
                                        ? primaryColor
                                        : Colors.grey[500],
                                    width: 3.0,
                                  ),
                                ),
                                width: 50.0,
                                alignment: Alignment.center,
                                child: Text(s),
                              ),
                            );
                          })?.toList() ??
                          [],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      onPressed: size != null
                          ? () {
                              if (UserModel.of(context).isLoggedIn()) {

                                CartProduct cartProduct = CartProduct();
                                cartProduct.size = size;
                                cartProduct.quantity = 1;
                                cartProduct.pid = data.id;
                                cartProduct.category = data.category;

                                CartModel.of(context).addCartItem(cartProduct);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CartScreen()));

                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              }
                            }
                          : null,
                      color: primaryColor,
                      child: Text(
                        UserModel.of(context).isLoggedIn()?"Adicionar ao Carrinho"
                        :"Faça o login para comprar   ",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Descrição:",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    data.description,
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
