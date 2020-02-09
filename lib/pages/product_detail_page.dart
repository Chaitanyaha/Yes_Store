import 'package:flutter/material.dart';
import 'package:yes_store/pages/products_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yes_store/models/app_state.dart';
import 'package:yes_store/redux/actions.dart';

class ProductDetailPage extends StatelessWidget {
  final dynamic item;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductDetailPage({this.item});

  bool _isInCart(AppState state, String id) {
    final List<dynamic> cartProducts = state.cartProducts;
    return cartProducts.indexWhere((cartProduct) => cartProduct.id == id) > -1;
  }

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://10.0.2.2:1337${item.pictures['url']}';
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(item.name),
        centerTitle: true,
      ),
      body: Container(
        decoration: gradientBackground,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Hero(
                  tag: item,
                  transitionOnUserGestures: true,
                  child: Image.network(
                    pictureUrl,
                    width: orientation == Orientation.portrait ? 300 : 170,
                    height: orientation == Orientation.portrait ? 300 : 170,
                    fit: BoxFit.cover,
                  ),
                )),
            Text(
              item.name,
              style: Theme.of(context).textTheme.title,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "\u20B9 " + '${item.cost}',
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: StoreConnector<AppState, AppState>(
                    converter: (store) => store.state,
                    builder: (_, state) {
                      return state.user != null
                          ? IconButton(
                              icon: Icon(Icons.shopping_cart),
                              color: _isInCart(state, item.id)
                                  ? Colors.blueGrey[500]
                                  : Colors.white,
                              onPressed: () {
                                StoreProvider.of<AppState>(context)
                                    .dispatch(toggleCartProductAction(item));
                                final snackbar = SnackBar(
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.grey[800],
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'Cart updated',
                                      style: TextStyle(color: Colors.green),
                                    ));
                                _scaffoldKey.currentState
                                    .showSnackBar(snackbar);
                              })
                          : Text('');
                    },
                  ),
                ),
              ],
            ),
            Flexible(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 20, bottom: 30),
                        child: Text('Description : \n'+ item.description))))
          ],
        ),
      ),
    );
  }
}
