import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task/core/navigation/app_routes.dart';
import 'package:task/core/services/services_locator.dart';
import 'package:task/core/utils/simple_bloc_observer.dart';
import 'package:task/features/products/domain/repository/products_repository.dart';
import 'package:task/features/products/domain/usecases/get_products_use_case.dart';
import 'package:task/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:task/features/products/presentation/screens/product_details_screen.dart';
import 'package:uni_links/uni_links.dart' as uni_links;

void main() async{
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  ServicesLocator().init();
  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp());

  configLoading();
}

Future<void> initDeepLinks(BuildContext context) async {
  // Check if the app was opened by a deep link
  final initialLink = await uni_links.getInitialLink();
  handleDeepLink(initialLink, context);

  // Listen for subsequent deep links while the app is running
  uni_links.linkStream.listen((uri) {
    handleDeepLink(uri, context);
  });
}

void handleDeepLink(String? uri, BuildContext context) {
  print("uri $uri");
  if (uri != null) {
    print(uri);
    List<String> uriParameters = uri.split("/");
    String productId = uriParameters[uriParameters.length-1];
    print("productId $productId");

    ProductsCubit productsCubit = BlocProvider.of<ProductsCubit>(context);

    productsCubit.getProducts();

    Navigator.push(context,
      MaterialPageRoute(builder: (context) => ProductDetailsScreen()),);
    // Process the deep link URI
    // Extract relevant information and navigate accordingly
    // For example, you can extract query parameters or path segments
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    );
    super.initState();

    initDeepLinks(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(414, 896),
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ProductsCubit(
                GetProductsUseCase(
                  sl.get<ProductsRepository>(),
                ),
              ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
          ),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
