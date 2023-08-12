import 'package:dartz/dartz.dart';
import 'package:task/core/error/failure.dart';
import 'package:task/core/usecase/base_usecase.dart';
import 'package:task/features/products/domain/entities/product_entity.dart';
import 'package:task/features/products/domain/repository/products_repository.dart';

class GetProductByIdUseCase extends UseCase<ProductEntity, int> {
  ProductsRepository productsRepository;
  GetProductByIdUseCase(this.productsRepository);

  @override
  Future<Either<Failure, ProductEntity>> call(int params) async {
    return await productsRepository.getProductById(productId: params);
  }
}
