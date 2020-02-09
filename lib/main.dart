import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yes_store/pages/home_screen.dart';

import 'package:yes_store/pages/login_page.dart';
import 'package:yes_store/pages/products_page.dart';
import 'package:yes_store/pages/register_page.dart';
import 'package:yes_store/redux/reducers.dart';
import 'package:yes_store/models/app_state.dart';
import 'package:yes_store/pages/cart_page.dart';
import 'redux/actions.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware, LoggingMiddleware.printer()]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Yes Store',
          theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.blueGrey[500],
              accentColor: Colors.grey[300],
              textTheme: TextTheme(
                  headline:
                      TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  title: TextStyle(
                    fontSize: 36,
                    fontStyle: FontStyle.italic,
                  ),
                  body1: TextStyle(
                    fontSize: 18,
                  ))),
          routes: {
            '/login': (BuildContext context) => LoginPage(),
            '/register': (BuildContext context) => RegisterPage(),
            '/product': (BuildContext context) => ProductsPage(onInit: () {
                  StoreProvider.of<AppState>(context).dispatch(getUserAction);
                  StoreProvider.of<AppState>(context)
                      .dispatch(getProductsAction);
                  //dispatch an action to grab user data
                }),
            '/cart': (BuildContext context) => CartPage(),
            '/': (BuildContext context) => HomeScreen(),
          },
        ));
  }
}
