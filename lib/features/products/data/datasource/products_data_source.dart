import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:task/core/error/exceptions.dart';
import 'package:task/core/network/error_message_model.dart';
import 'package:task/core/utils/app_constants.dart';
import 'package:task/features/products/data/models/product_model.dart';
import 'package:task/features/products/data/models/products_request_model.dart';
import 'package:task/features/products/domain/entities/product_entity.dart';

abstract class ProductsDataSource {
  Future<List<ProductEntity>> getProducts(
      {required ProductsRequestModel productsRequestModel});

  Future<ProductEntity> getProductById({required int productId});
}

class ProductsDataSourceImpl extends ProductsDataSource {
  @override
  Future<List<ProductEntity>> getProducts(
      {required ProductsRequestModel productsRequestModel}) async {
    final response = await Dio().get(
        "${AppConstants.getProductsUrl}?skip=${productsRequestModel.skip}&limit=${productsRequestModel.limit}");
    if (response.statusCode == 200) {
      return List<ProductModel>.from((response.data["products"] as List)
          .map((e) => ProductModel.fromJson(e)));
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<ProductEntity> getProductById({required int productId}) async {
    final response =
        await Dio().get("${AppConstants.getProductByIdUrl}/$productId");
    if (response.statusCode == 200) {
      return ProductModel.fromJson(
        jsonDecode(response.toString()) as Map<String, dynamic>,
      );
    } else {
      throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data));
    }
  }
}
