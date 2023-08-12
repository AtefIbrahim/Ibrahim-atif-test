import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/features/products/data/models/products_request_model.dart';
import 'package:task/features/products/domain/entities/product_entity.dart';
import 'package:task/features/products/domain/usecases/get_products_use_case.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.getProductsUseCase) : super(ProductsInitial());
  final GetProductsUseCase getProductsUseCase;

  List<ProductEntity> cartList = [];

  Future<void> getProducts() async {
    emit(ProductsIsLoading());
    var result =
        await getProductsUseCase.call(ProductsRequestModel(skip: 0, limit: 4));
    result.fold((failure) {
      emit(ProductsFailure(failure.message));
    }, (List<ProductEntity> productsList) {
      emit(ProductsSuccess(
        productsList: productsList,
        hasReachedMax: productsList.length == 4 ? false : true,
      ));
    });
  }

  Future<void> loadMoreProducts() async {
    final ProductsSuccess currState = state as ProductsSuccess;

    if (currState.hasReachedMax == false) {
      emit(
        ProductsSuccess(
          productsList: currState.productsList,
          hasReachedMax: currState.hasReachedMax,
          inProgress: true,
        ),
      );

      var result = await getProductsUseCase(
        ProductsRequestModel(skip: currState.productsList.length, limit: 4),
      );

      result.fold((failure) {
        emit(ProductsFailure(failure.message));
      }, (List<ProductEntity> productsList) {
        currState.productsList.addAll(productsList);
        emit(
          ProductsSuccess(
            productsList: currState.productsList,
            hasReachedMax: productsList.length == 4 ? false : true,
          ),
        );
      });
    }
  }

  addItemToCart(ProductEntity newItem) {
    if (cartList.contains(newItem)) {
      int index = cartList.indexOf(newItem);
      cartList[index].count++;
    } else {
      newItem.count++;
      cartList.add(newItem);

      final ProductsSuccess currState = state as ProductsSuccess;
      emit(ProductsSuccess(
        productsList: currState.productsList,
        hasReachedMax: currState.hasReachedMax,
      ),);
    }
  }

  increaseCountOfCartItem(int index) {
    cartList[index].count++;
    final ProductsSuccess currState = state as ProductsSuccess;
    emit(ProductsSuccess(
      productsList: currState.productsList,
      hasReachedMax: currState.hasReachedMax,
    ),);
  }

  decreaseCountOfCartItem(int index) {
    cartList[index].count--;
    if (cartList[index].count == 0) {
      cartList.removeAt(index);
    }

    final ProductsSuccess currState = state as ProductsSuccess;
    emit(ProductsSuccess(
      productsList: currState.productsList,
      hasReachedMax: currState.hasReachedMax,
    ),);
  }

  double getCartCost() {
    double totalCost = 0;
    cartList.forEach((element) {
      totalCost += ((element.price! -
              (element.price! * (element.discountPercentage ?? 0)) / 100) *
          element.count);
    });

    return double.parse(totalCost.toStringAsFixed(2));
  }

  getLengthOfCart() {
    return cartList.length;
  }
}
