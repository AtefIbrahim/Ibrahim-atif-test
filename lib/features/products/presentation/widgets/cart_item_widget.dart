import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task/core/utils/palette.dart';
import 'package:task/core/utils/styles.dart';
import 'package:task/features/products/domain/entities/product_entity.dart';
import 'package:task/features/products/presentation/managers/products_cubit/products_cubit.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.productsCubit,
    required this.product,
    required this.index,
  });
  final ProductsCubit productsCubit;
  final ProductEntity product;
  final int index;

  @override
  Widget build(BuildContext context) {
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
              imageUrl: product.thumbnail!,
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
              errorWidget: (BuildContext context, String url, error) =>
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
                  height: 12.h,
                ),
                Text(product.title!,
                    textAlign: TextAlign.start,
                    style: Styles.titleStyle18.copyWith(
                      color: Palette.kBlack,
                      fontWeight: FontWeight.w700,
                    )),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                        "\$${(product.price! - (product.price! * product.discountPercentage!) / 100).toStringAsFixed(2)}",
                        style: Styles.titleStyle14.copyWith(
                            color: Palette.kBlack,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text("\$${product.price!}",
                        style: Styles.titleStyle14.copyWith(
                            color: Palette.greyBorder,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Palette.greyBorder,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationThickness: 3.w,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text("${product.discountPercentage!}% off",
                        style: Styles.titleStyle14.copyWith(
                            color: Palette.greyBorder,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        productsCubit.decreaseCountOfCartItem(index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.h, vertical: 8.w),
                        decoration: BoxDecoration(
                          color: Palette.kBlack,
                          border: Border.all(color: Palette.greyBorder),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Palette.kWhite,
                          size: 32.w,
                        ),
                      ),
                    ),
                    Text("${product.count}",
                        style: Styles.titleStyle18.copyWith(
                            color: Palette.greyBorder,
                            fontWeight: FontWeight.w500)),
                    InkWell(
                      onTap: () {
                        productsCubit.increaseCountOfCartItem(index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.h, vertical: 8.w),
                        decoration: BoxDecoration(
                          color: Palette.kBlack,
                          border: Border.all(color: Palette.greyBorder),
                          borderRadius: BorderRadius.circular(10.r),
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
  }
}
