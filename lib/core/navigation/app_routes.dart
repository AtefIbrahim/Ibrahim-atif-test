import 'package:go_router/go_router.dart';
import 'package:task/core/navigation/routes.dart';
import 'package:task/features/products/domain/entities/product_entity.dart';
import 'package:task/features/products/presentation/screens/cart_screen.dart';
import 'package:task/features/products/presentation/screens/product_details_screen.dart';
import 'package:task/features/products/presentation/screens/products_screen.dart';

abstract class AppRouter {
  static const String initial = Routers.productsScreen;

  static final GoRouter router = GoRouter(
    initialLocation: initial,
    routes: routes,
  );

  // GoRouter configuration
  static final List<GoRoute> routes = <GoRoute>[
    GoRoute(
      path: Routers.productsScreen,
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
        path: Routers.productDetailsScreen,
        builder: (context, state) => ProductDetailsScreen(
              product: state.extra! as ProductEntity,
            )),
    GoRoute(
      path: Routers.cartScreen,
      builder: (context, state) => const CartScreen(),
    ),
  ];
}
