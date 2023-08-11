part of 'products_cubit.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsIsLoading extends ProductsState {
  List<Object?> get props => [];
}

class ProductsFailure extends ProductsState {
  final String errorMessage;
  ProductsFailure(this.errorMessage);

  List<Object?> get props => [errorMessage];
}

class ProductsSuccess extends ProductsState {
  final List<ProductEntity> productsList;
  bool? inProgress;
  bool? hasReachedMax;

  ProductsSuccess({
    required this.productsList,
    this.inProgress = false,
    this.hasReachedMax = false,
  });

  List<Object?> get props => [productsList];
}
