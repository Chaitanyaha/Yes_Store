import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:yes_store/models/app_state.dart';
import 'package:yes_store/models/product.dart';
import 'package:yes_store/pages/product_detail_page.dart';
import 'package:yes_store/redux/actions.dart';

class ProductItem extends StatelessWidget {
  final Product item;

  ProductItem({this.item});

  bool _isInCart(AppState state, String id) {
    final List<dynamic> cartProducts = state.cartProducts;
    return cartProducts.indexWhere((cartProduct) => cartProduct.id == id) > -1;
  }

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://10.0.2.2:1337${item.pictures['url']}';

    return InkWell(
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ProductDetailPage(item: item);
      })),
      child: GridTile(
          child: Hero(
            tag: item,
            child: Image.network(
              pictureUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
              title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  item.name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              subtitle: Text(
                'Rs. ${item.cost}',
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Color(0x99000000),
              trailing: StoreConnector<AppState, AppState>(
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
                          })
                      : Text('');
                },
              ))),
    );
  }
}
