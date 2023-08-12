import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task/core/navigation/routes.dart';
import 'package:task/core/utils/palette.dart';
import 'package:task/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:task/features/products/presentation/screens/product_details_screen.dart';
import 'package:uni_links/uni_links.dart' as uni_links;
import 'package:task/features/products/domain/entities/product_entity.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), (){
      initDeepLinks(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.kWhite,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset("assets/images/logo.jpg"),
      ),
    );
  }

  Future<void> initDeepLinks(BuildContext context) async {
    // Check if the app was opened by a deep link
    final initialLink = await uni_links.getInitialLink();
    handleDeepLink(initialLink);

    // Listen for subsequent deep links while the app is running
    uni_links.linkStream.listen((uri) {
      handleDeepLink(uri);
    });
  }

  void handleDeepLink(String? uri) async{
    print("uri $uri");
    if (uri != null) {
      print(uri);
      List<String> uriParameters = uri.split("/");
      String productId = uriParameters[uriParameters.length - 1];
      print("productId $productId");

      ProductsCubit productsCubit = BlocProvider.of<ProductsCubit>(context);

      ProductEntity? product = await productsCubit.getProductById(int.parse(productId));

      log(product.toString());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product!,)),
      );
      //context.push(Routers.productDetailsScreen, extra: product);
      // Process the deep link URI
      // Extract relevant information and navigate accordingly
      // For example, you can extract query parameters or path segments
    }
    else
      {
        context.push(Routers.productsScreen,);
      }
  }

}
