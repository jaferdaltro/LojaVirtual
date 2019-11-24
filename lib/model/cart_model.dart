import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;

  List<CartProduct> products = [];


  CartModel(this.user);

  addCartItem(CartProduct product){
    products.add(product);

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").add(product.toMap()).then((p){
      product.cid = p.documentID;
    });
    notifyListeners();
  }

  removeCartItem(CartProduct product){
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(product.cid).delete();
    products.remove(product);
    notifyListeners();
  }

}