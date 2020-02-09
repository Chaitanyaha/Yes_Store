import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:yes_store/models/app_state.dart';
import 'package:yes_store/widgets/product_item.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Widget _cartTab() {
    final orientation = MediaQuery.of(context).orientation;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return Column(
          children: <Widget>[
            Expanded(
                child: SafeArea(
              top: false,
              bottom: false,
              child: GridView.builder(
                  itemCount: state.cartProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio:
                        orientation == Orientation.portrait ? 1.0 : 1.3,
                  ),
                  itemBuilder: (context, i) =>
                      ProductItem(item: state.cartProducts[i])),
            ))
          ],
        );
      },
    );
  }

  Widget _cardsTab() {
    return Text('card');
  }

  Widget _ordersTab() {
    return Text('orders');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text('ThankYou! for shopping'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.shopping_cart)),
                Tab(icon: Icon(Icons.credit_card)),
                Tab(icon: Icon(Icons.receipt)),
              ],
              labelColor: Color(0xffd53369),
              unselectedLabelColor: Color(0xffcbad6d),
            ),
          ),
          body: TabBarView(children: [
            _cartTab(),
            _cardsTab(),
            _ordersTab(),
          ]),
        ));
  }
}
