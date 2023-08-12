import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task/core/utils/app_strings.dart';
import 'package:task/core/utils/palette.dart';
import 'package:task/core/utils/styles.dart';
import 'package:task/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:task/features/products/presentation/widgets/cart_item_widget.dart';
import 'package:task/features/products/presentation/widgets/custom_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late ProductsCubit productsCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productsCubit = BlocProvider.of<ProductsCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.cart,
            style: Styles.titleStyle18.copyWith(
              color: Palette.kBlack,
            )),
        backgroundColor: Palette.kWhite,
        leading: InkWell(
            onTap: () {
              context.pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Palette.kBlack,
              size: 28.w,
            )),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 16.w),
        //     child: Center(
        //       child: BlocBuilder<ProductsCubit, ProductsState>(
        //         bloc: productsCubit, // provide the local bloc instance
        //         builder: (context, state) {
        //           return badges.Badge(
        //             badgeContent:
        //                 Text(productsCubit.getLengthOfCart().toString()),
        //             child: Icon(
        //               Icons.shopping_cart,
        //               color: Palette.kBlack,
        //               size: 28.w,
        //             ),
        //           );
        //         },
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocBuilder<ProductsCubit, ProductsState>(
          bloc: productsCubit, // provide the local bloc instance
          builder: (context, state) {
            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  itemCount: productsCubit.cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CartItem(
                      product: productsCubit.cartList[index],
                      productsCubit: productsCubit,
                      index: index,
                    );
                  },
                ),
                SizedBox(
                  height: 75.h,
                ),
                productsCubit.cartList.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 32.h),
                        child: CustomElevatedButton(
                          onPressed: () {},
                          backgroundColor: Palette.kBlack,
                          borderColor: Palette.kBlack,
                          width: 340.w,
                          height: 55.h,
                          text: "${productsCubit.getCartCost()}",
                          textStyle: Styles.titleStyle18.copyWith(
                            color: Palette.kWhite,
                          ),
                          textColor: Palette.kWhite,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}
