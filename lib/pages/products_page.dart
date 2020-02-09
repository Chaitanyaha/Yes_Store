import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:yes_store/models/app_state.dart';
import 'package:yes_store/redux/actions.dart';
import 'package:yes_store/widgets/product_item.dart';

final gradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xffc21500),
      Color(0xffffc500),
    ],
  ),
);

class ProductsPage extends StatefulWidget {
  final void Function() onInit; //Function() to run immediatly as app starts

  ProductsPage({this.onInit});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  //to retrieve the data from shared prefrences to read add a lifecycle method initState--> executes async action to update the widgets
  void initState() {
    super.initState();
    widget.onInit();
  }

  final _appBar = PreferredSize(
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return AppBar(
            centerTitle: true,
            leading: state.user != null
                ? BadgeIconButton(
                    itemCount: state.cartProducts.length,
                    badgeColor: Colors.lime,
                    badgeTextColor: Colors.black,
                    icon: Icon(Icons.store),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  )
                : Text(''),
            title: state.user != null
                ? Text(state.user.username)
                : FlatButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: Text(
                      'Register Here',
                      style: Theme.of(context).textTheme.body1,
                    )),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: StoreConnector<AppState, VoidCallback>(
                      /* no arguments and data is passed hence void callback*/
                      converter: (store) {
                    return () => store.dispatch(logoutUserAction);
                  }, builder: (_, callback) {
                    return state.user != null
                        ? IconButton(
                            icon: Icon(Icons.exit_to_app),
                            onPressed: callback,
                          )
                        : Text('');
                  }
                      //IconButton(icon: Icon(Icons.exit_to_app), onPressed: () {})
                      ))
            ],
          );
        },
      ),
      preferredSize: Size.fromHeight(60));

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: _appBar,
      body: Container(
        child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return Column(
              children: <Widget>[
                Expanded(
                    child: SafeArea(
                  top: false,
                  bottom: false,
                  child: GridView.builder(
                      itemCount: state.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                        childAspectRatio:
                            orientation == Orientation.portrait ? 1.0 : 1.3,
                      ),
                      itemBuilder: (context, i) =>
                          ProductItem(item: state.products[i])),
                ))
              ],
            );
          },
        ),
        decoration: gradientBackground,
      ),
    );
  }
}
