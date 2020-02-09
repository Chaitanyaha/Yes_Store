import 'package:yes_store/models/app_state.dart';
import 'package:yes_store/models/product.dart';
import 'package:yes_store/models/user.dart';
import 'package:yes_store/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(state.user, action),
    products: productsReducer(state.products, action),
    cartProducts: cartProducts(state.cartProducts, action),
  );
}

User userReducer(User user, dynamic action) {
  if (action is GetUserAction) {
    return action.user;
  } else if (action is LogoutUserAction) {
    return action.user;
  }
  return user;
}

productsReducer(products, action) {
  if (action is GetProductsAction) {
    return action.products;
  }
  return products;
}

cartProducts(cartProducts, action) {
  if (action is ToggleCartProductAction) {
    return action.cartProducts;
  }
  return cartProducts;
}
