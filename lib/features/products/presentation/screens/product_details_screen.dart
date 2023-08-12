import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task/core/navigation/routes.dart';
import 'package:task/core/utils/app_strings.dart';
import 'package:task/core/utils/palette.dart';
import 'package:task/core/utils/styles.dart';
import 'package:task/features/products/domain/entities/product_entity.dart';
import 'package:task/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:task/features/products/presentation/widgets/custom_button.dart';
import 'package:task/features/products/presentation/widgets/product_google_map_widget.dart';
import 'package:task/features/products/presentation/widgets/row_text_info.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final ProductEntity product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductsCubit productsCubit;

  int activeTopSliderIndex = 0;
  CarouselController? carouselControllerTopSlider = CarouselController();
  int activeBottomSliderIndex = 0;
  CarouselController? carouselControllerBottomSlider = CarouselController();

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
        title: Text(AppStrings.productDetails,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            CarouselSlider.builder(
              carouselController: carouselControllerTopSlider,
              itemCount: widget.product.images!.length,
              options: CarouselOptions(
                height: 350.h,
                aspectRatio: 1,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                autoPlay: true,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                autoPlayInterval: const Duration(seconds: 2),
                onPageChanged: (int index, CarouselPageChangedReason e) {
                  setState(() {
                    activeTopSliderIndex = index;
                  });
                },
              ),
              itemBuilder: (
                BuildContext context,
                int itemIndex,
                int pageViewIndex,
              ) {
                return CachedNetworkImage(
                  imageUrl: widget.product.images![itemIndex],
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
                );
              },
            ),
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  Text(widget.product.title!,
                      textAlign: TextAlign.start,
                      style: Styles.titleStyle20.copyWith(
                        color: Palette.kBlack,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(
                    height: 16.h,
                  ),
                  //price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "\$${(widget.product.price! - (widget.product.price! * widget.product.discountPercentage!) / 100).toStringAsFixed(2)}",
                          style: Styles.titleStyle18.copyWith(
                              color: Palette.kBlack,
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text("\$${widget.product.price!}",
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
                      Text("${widget.product.discountPercentage!}% off",
                          style: Styles.titleStyle18.copyWith(
                              color: Palette.greyBorder,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  //description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${AppStrings.description}: ",
                          textAlign: TextAlign.start,
                          style: Styles.titleStyle20.copyWith(
                            color: Palette.kBlack,
                            fontWeight: FontWeight.w700,
                          )),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(widget.product.description!,
                          textAlign: TextAlign.start,
                          style: Styles.titleStyle20.copyWith(
                            color: Palette.kBlack.withOpacity(0.5),
                            fontWeight: FontWeight.w700,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  //category
                  RowTextInfo(title: "${AppStrings.category}: ", value: widget.product.category ?? "",),
                  SizedBox(
                    height: 16.h,
                  ),
                  //brand
                  RowTextInfo(title: "${AppStrings.brand}: ", value: widget.product.brand ?? "",),
                  SizedBox(
                    height: 16.h,
                  ),
                  //store
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${AppStrings.rate}: ",
                          textAlign: TextAlign.start,
                          style: Styles.titleStyle20.copyWith(
                            color: Palette.kBlack,
                            fontWeight: FontWeight.w700,
                          )),
                      SizedBox(
                        width: 15.w,
                      ),
                      RatingBar.builder(
                        initialRating: widget.product.rating!.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  //map
                  const ProductGoogleMap(),
                  SizedBox(
                    height: 32.h,
                  ),
                  //Add To Cart
                  CustomElevatedButton(
                    onPressed: () {
                      productsCubit.addItemToCart(widget.product);
                    },
                    backgroundColor: Palette.kBlack,
                    borderColor: Palette.kBlack,
                    width: 400.w,
                    height: 55.h,
                    text: "Add To Cart",
                    textStyle: Styles.titleStyle18.copyWith(
                      color: Palette.kWhite,
                    ),
                    textColor: Palette.kWhite,
                  ),
                  SizedBox(
                    height: 32.h,
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
