import '../models/product.dart';
import '../web_services/products_web_services.dart';

class ProductsRepository {
  final ProductsWebServices productsWebServices;
  ProductsRepository(this.productsWebServices);

  Future<List<Product>> getAllProducts() async {
    final products = await productsWebServices.getAllProducts();
    return products.map((product) => Product.fromJson(product)).toList();
  }
}
