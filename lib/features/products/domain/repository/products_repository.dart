import 'package:dartz/dartz.dart';
import 'package:task/core/error/failure.dart';
import 'package:task/features/products/data/models/products_request_model.dart';
import 'package:task/features/products/domain/entities/product_entity.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts(
      {required ProductsRequestModel productsRequestModel});
}
