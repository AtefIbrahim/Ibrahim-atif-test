import 'package:get_it/get_it.dart';
import 'package:task/features/products/data/datasource/products_data_source.dart';
import 'package:task/features/products/data/repository/products_repository_implmentation.dart';
import 'package:task/features/products/domain/repository/products_repository.dart';
import 'package:task/features/products/domain/usecases/get_product_by_id_use_case.dart';
import 'package:task/features/products/domain/usecases/get_products_use_case.dart';
import 'package:task/features/products/presentation/managers/products_cubit/products_cubit.dart';

final sl = GetIt.instance;

class ServicesLocator {
  init() {
    /// Data Source
    sl.registerLazySingleton<ProductsDataSource>(
        () => ProductsDataSourceImpl());

    /// Repository
    sl.registerLazySingleton<ProductsRepository>(
        () => ProductsRepositoryImplementation(sl()));

    /// Use Cases
    sl.registerLazySingleton(() => GetProductsUseCase(sl()));
    sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));

    /// Bloc
    sl.registerFactory<ProductsCubit>(() =>
        ProductsCubit(getProductsUseCase: sl(), getProductByIdUseCase: sl()));
  }
}
