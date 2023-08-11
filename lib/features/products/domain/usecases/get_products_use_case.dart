import 'package:dartz/dartz.dart';
import 'package:task/core/error/failure.dart';
import 'package:task/core/usecase/base_usecase.dart';
import 'package:task/features/products/data/models/products_request_model.dart';
import 'package:task/features/products/domain/entities/product_entity.dart';
import 'package:task/features/products/domain/repository/products_repository.dart';

class GetProductsUseCase
    extends UseCase<List<ProductEntity>, ProductsRequestModel> {
  ProductsRepository productsRepository;
  GetProductsUseCase(this.productsRepository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
      ProductsRequestModel params) async {
    return await productsRepository.getProducts(productsRequestModel: params);
  }
}
