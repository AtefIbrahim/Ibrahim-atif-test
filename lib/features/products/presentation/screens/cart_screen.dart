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
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                bloc: productsCubit, // provide the local bloc instance
                builder: (context, state) {
                  return badges.Badge(
                    badgeContent:
                        Text(productsCubit.getLengthOfCart().toString()),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Palette.kBlack,
                      size: 28.w,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocBuilder<ProductsCubit, ProductsState>(
          bloc: productsCubit, // provide the local bloc instance
          builder: (context, state) {
            return Expanded(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    itemCount: productsCubit.cartList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.r),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    productsCubit.cartList[index].thumbnail!,
                                height: 150.h,
                                width: 120.w,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (
                                  BuildContext context,
                                  String url,
                                  DownloadProgress downloadProgress,
                                ) {
                                  return Center(
                                    child: SizedBox(
                                      width: 32.w,
                                      height: 32.h,
                                      child: CircularProgressIndicator(
                                        color: Palette.kLightBlue,
                                        value: downloadProgress.progress,
                                      ),
                                    ),
                                  );
                                },
                                errorWidget:
                                    (BuildContext context, String url, error) =>
                                        const Icon(Icons.error),
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(productsCubit.cartList[index].title!,
                                      textAlign: TextAlign.start,
                                      style: Styles.titleStyle20.copyWith(
                                        color: Palette.kBlack,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                            "\$${(productsCubit.cartList[index].price! - (productsCubit.cartList[index].price! * productsCubit.cartList[index].discountPercentage!) / 100).toStringAsFixed(2)}",
                                            style: Styles.titleStyle18.copyWith(
                                                color: Palette.kBlack,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                            "\$${productsCubit.cartList[index].price!}",
                                            style: Styles.titleStyle18.copyWith(
                                                color: Palette.greyBorder,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor:
                                                    Palette.greyBorder,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                decorationThickness: 3.w,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                            "${productsCubit.cartList[index].discountPercentage!}% off",
                                            style: Styles.titleStyle18.copyWith(
                                                color: Palette.greyBorder,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          productsCubit
                                              .decreaseCountOfCartItem(index);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.h, vertical: 8.w),
                                          decoration: BoxDecoration(
                                            color: Palette.kBlack,
                                            border: Border.all(
                                                color: Palette.greyBorder),
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            color: Palette.kWhite,
                                            size: 32.w,
                                          ),
                                        ),
                                      ),
                                      Text(
                                          "${productsCubit.cartList[index].count}",
                                          style: Styles.titleStyle18.copyWith(
                                              color: Palette.greyBorder,
                                              fontWeight: FontWeight.w500)),
                                      InkWell(
                                        onTap: () {
                                          productsCubit
                                              .increaseCountOfCartItem(index);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.h, vertical: 8.w),
                                          decoration: BoxDecoration(
                                            color: Palette.kBlack,
                                            border: Border.all(
                                                color: Palette.greyBorder),
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Palette.kWhite,
                                            size: 32.w,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
