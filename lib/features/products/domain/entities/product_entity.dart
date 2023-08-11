import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final int? price;
  final num? discountPercentage;
  final num? rating;
  final int? stock;
  final String? brand;
  final String? category;
  final String? thumbnail;
  final List<String>? images;
  int count;

  ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
    this.count = 0,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id!,
        title!,
        description!,
        price!,
        discountPercentage!,
        rating!,
        stock!,
        brand!,
        category!,
        thumbnail!,
        images!,
        count,
      ];
}
