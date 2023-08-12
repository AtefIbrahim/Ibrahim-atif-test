import 'package:dartz/dartz.dart';
import 'package:task/core/error/exceptions.dart';
import 'package:task/core/error/failure.dart';
import 'package:task/features/products/data/datasource/products_data_source.dart';
import 'package:task/features/products/data/models/products_request_model.dart';
import 'package:task/features/products/domain/entities/product_entity.dart';
import 'package:task/features/products/domain/repository/products_repository.dart';

class ProductsRepositoryImplementation extends ProductsRepository {
  final ProductsDataSource productsDataSource;
  ProductsRepositoryImplementation(this.productsDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts(
      {required ProductsRequestModel productsRequestModel}) async {
    final result = await productsDataSource.getProducts(
        productsRequestModel: productsRequestModel);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
          ServerFailure(message: failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(
      {required int productId}) async {
    final result =
        await productsDataSource.getProductById(productId: productId);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
          ServerFailure(message: failure.errorMessageModel.statusMessage));
    }
  }
}
