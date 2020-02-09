import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yes_store/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:yes_store/models/user.dart';
import 'package:yes_store/models/product.dart';

/*User Action */

ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  //thunkaction gets the data and pass that data to action which is going to be picked up by the reducer
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;

  store.dispatch(GetUserAction(user));
};

class GetUserAction {
  final User _user;

  User get user => this._user;

  GetUserAction(this._user);
}

ThunkAction<AppState> getProductsAction = (Store<AppState> store) async {
  http.Response response = await http.get('http://10.0.2.2:1337/products');
  final List<dynamic> responseData = json.decode(response.body);
  List<dynamic> products = [];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    products.add(product);
  });
  store.dispatch(GetProductsAction(products));
};

class GetProductsAction {
  final List<dynamic> _products;

  List<dynamic> get products => this._products;

  GetProductsAction(this._products);
}

ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User user; //passing null value
  store.dispatch(LogoutUserAction(user));
};

class LogoutUserAction {
  final User _user;

  User get user => this._user;

  LogoutUserAction(this._user);
}

ThunkAction<AppState> toggleCartProductAction(cartProduct) {
  return (Store<AppState> store) {
    final List<dynamic> cartProducts = store.state.cartProducts;
    final int index =
        cartProducts.indexWhere((product) => product.id == cartProduct.id);
    bool isInCart = index > -1 == true;
    List<dynamic> updatedCartProducts = List.from(cartProducts);

    if (isInCart) {
      updatedCartProducts.removeAt(index);
    } else {
      updatedCartProducts.add(cartProduct);
    }
    store.dispatch(ToggleCartProductAction(updatedCartProducts));
  };
}

class ToggleCartProductAction {
  final List<dynamic> _cartProducts;
  List<dynamic> get cartProducts => this._cartProducts;
  ToggleCartProductAction(this._cartProducts);
}
