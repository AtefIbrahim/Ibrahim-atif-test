import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task/core/navigation/routes.dart';
import 'package:task/core/utils/app_strings.dart';
import 'package:task/core/utils/palette.dart';
import 'package:task/core/utils/styles.dart';
import 'package:task/core/widgets/loader.dart';
import 'package:task/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:task/features/products/presentation/widgets/product_widget.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ProductsCubit productsCubit;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productsCubit = BlocProvider.of<ProductsCubit>(context);
    productsCubit.getProducts();
    ViewsToolbox.showLoading();

    _scrollListener();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  _scrollListener() {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;

      if (maxScroll == currentScroll) {
        productsCubit.loadMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.kWhite,
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.products,
            style: Styles.titleStyle18.copyWith(
              color: Palette.kBlack,
            )),
        backgroundColor: Palette.kWhite,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                bloc: productsCubit, // provide the local bloc instance
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      context.push(
                        Routers.cartScreen,
                      );
                    },
                    child: badges.Badge(
                      badgeContent:
                          Text(productsCubit.getLengthOfCart().toString()),
                      child: Icon(
                        Icons.shopping_cart,
                        color: Palette.kBlack,
                        size: 28.w,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: BlocProvider<ProductsCubit>.value(
        value: productsCubit,
        child: BlocConsumer<ProductsCubit, ProductsState>(
            listener: (BuildContext context, state) {
          if (state is ProductsIsLoading) {
            ViewsToolbox.showLoading();
          } else if (state is ProductsSuccess) {
            ViewsToolbox.dismissLoading();
            if (state.inProgress!) {
              ViewsToolbox.showLoading();
            } else {
              ViewsToolbox.dismissLoading();
            }
          } else if (state is ProductsFailure) {
            ViewsToolbox.dismissLoading();
            ViewsToolbox.showSnackBar(context, state.errorMessage);
          }
        }, builder: (context, state) {
          return BlocBuilder<ProductsCubit, ProductsState>(
              builder: (BuildContext context, state) {
            if (state is ProductsSuccess) {
              return ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                itemCount: state.productsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ProductWidget(
                    product: state.productsList[index],
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          });
        }),
      ),
    );
  }
}
