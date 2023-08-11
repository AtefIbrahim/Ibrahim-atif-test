import 'package:go_router/go_router.dart';
import 'package:task/core/navigation/app_routes.dart';
import 'package:task/core/navigation/routes.dart';
import 'package:task/core/utils/app_strings.dart';
import 'package:task/features/products/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task/core/utils/palette.dart';
import 'package:task/core/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.push(Routers.productDetailsScreen, extra: product);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.r), topLeft: Radius.circular(15.r)),
          border: Border.all(color: Palette.greyBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.r),
                  topLeft: Radius.circular(15.r)),
              child: CachedNetworkImage(
                imageUrl: product.thumbnail!,
                height: 250.h,
                width: double.infinity,
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
              height: 16.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title!,
                      textAlign: TextAlign.start,
                      style: Styles.titleStyle18.copyWith(
                        color: Palette.kLightRed,
                      )),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(product.description!,
                      style: Styles.titleStyle18.copyWith(
                          color: Palette.kBlack, fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "\$${(product.price! - (product.price! * product.discountPercentage!) / 100).toStringAsFixed(2)}",
                          style: Styles.titleStyle18.copyWith(
                              color: Palette.kBlack,
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text("\$${product.price!}",
                          style: Styles.titleStyle18.copyWith(
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
                          style: Styles.titleStyle18.copyWith(
                              color: Palette.greyBorder,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
