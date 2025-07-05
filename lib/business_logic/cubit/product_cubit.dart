import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/product.dart';
import '../../data/repository/products_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductsRepository productsRepository;
  List<Product> allProducts = [];
  List<Product> searchedProducts = [];
  List<Product> categoryProducts = [];
  ProductCubit(this.productsRepository) : super(ProductInitial());
  List<Product> getAllProducts() {
    productsRepository.getAllProducts().then((product) {
      emit(ProductsLoaded(product));
      this.allProducts = product;
    });
    return allProducts;
  }

  void getSearchedProducts(String searchedProduct) {
    searchedProducts = allProducts
        .where(
          (product) => product.title.toLowerCase().startsWith(searchedProduct),
        )
        .toList();
    emit(ProductsLoaded(searchedProducts));
  }

  void getCategorisedProducts(String category, int index) {
    if (index != 0) {
      categoryProducts = allProducts
          .where(
            (product) => product.category.toLowerCase().startsWith(category),
          )
          .toList();
    } else {
      categoryProducts = allProducts;
    }

    emit(ProductsLoaded(categoryProducts));
  }

  void getAllCategorises() {
    emit(ProductsLoaded(allProducts));
  }

  Product? getProductById(int id) {
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
