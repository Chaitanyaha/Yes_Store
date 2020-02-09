import 'package:meta/meta.dart';
import 'package:yes_store/models/product.dart';


@immutable //we can't change previous state values when there's new action taking place
class AppState {
  final dynamic user;
  final List<dynamic> products;
  final List<dynamic> cartProducts;

  AppState(
      {@required this.user,
      @required this.products,
      @required this.cartProducts});

  factory AppState.initial() {
    //factory constructor doesn’t always create a new instance of its class initial is used as redirecting constructor
    return AppState(user: null, products: [], cartProducts: []);
  }
}
