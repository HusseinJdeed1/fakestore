import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/cart_cubit.dart';
import '../../business_logic/cubit/product_cubit.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_strings.dart';
import '../../data/models/cart_new.dart';
import '../../data/models/product.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/styled_title_text.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late int userId;
  late CartNew? cartNew;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //BlocProvider.of<CartCubit>(context).loadCartFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledTitleText(
                  text: "Cart",
                  fontSize: 35,
                ),
                ModeToggle(),
              ],
            ),
            Expanded(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  double totalPrice = 0;

                  if (state is CartLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CartLoaded) {
                    final cart = state.userCart;
                    final products = cart.products ?? [];

                    if (products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/empty-cart.png",
                              width: 200,
                              height: 200,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your cart is empty!',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    totalPrice = calculateTotalPrice(products, context);

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return buildCartViewBuilder(
                                  context, index, products);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "Total Price: ${totalPrice.toStringAsFixed(2)} \$",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: checkOutButton(context)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is CartError) {
                    return Center(child: Text("Error: ${state.error}"));
                  } else {
                    return Center(child: Text("No Cart Data"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildIncreaseQuantityButton(List<CartProduct> products, int index) {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: MyColors.myBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.add, color: MyColors.myGrey2, size: 16),
        onPressed: () {
          increaseQuantity(products, index);
        },
      ),
    );
  }

  void increaseQuantity(List<CartProduct> products, int index) {
    final currentQty = products[index].quantity!;
    setState(() {
      products[index].quantity = currentQty + 1;
    });
    BlocProvider.of<CartCubit>(context).saveCartToLocal();
  }

  buildDecreaseQuantityButton(
      List<CartProduct> products, int index, int productId) {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.remove, color: MyColors.myGrey2, size: 16),
        onPressed: () {
          decreaseQuantity(products, index, productId);
        },
      ),
    );
  }

  void decreaseQuantity(List<CartProduct> products, int index, int productId) {
    final currentQty = products[index].quantity!;
    if (currentQty > 1) {
      setState(() {
        products[index].quantity = currentQty - 1;
      });
      BlocProvider.of<CartCubit>(context).saveCartToLocal();
    } else {
      BlocProvider.of<CartCubit>(context).removeProductFromCart(productId!);
    }
  }

  buildRemoveFromCartButton(int productId) {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.delete, color: MyColors.myGrey2, size: 18),
        onPressed: () {
          BlocProvider.of<CartCubit>(context).removeProductFromCart(productId);
        },
      ),
    );
  }

  buildCartViewBuilder(
      BuildContext context, int index, List<CartProduct> products) {
    final productId = products[index].productId;
    Product? product =
        BlocProvider.of<ProductCubit>(context).getProductById(productId!);

    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  productDetailsScreen,
                  arguments: product,
                );
              },
              child: Image.network(
                product!.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$ ${product.price}",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 2, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildIncreaseQuantityButton(products, index),
                  SizedBox(height: 2),
                  Text(
                    "${products[index].quantity}",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  buildDecreaseQuantityButton(
                    products,
                    index,
                    productId,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            buildRemoveFromCartButton(productId),
          ],
        ),
      ),
    );
  }

  double calculateTotalPrice(List<CartProduct> products, BuildContext cotext) {
    return products.fold(0.0, (sum, item) {
      final product =
          BlocProvider.of<ProductCubit>(cotext).getProductById(item.productId!);
      if (product != null) {
        return sum + (product.price * item.quantity!);
      }
      return sum;
    });
  }

  Widget checkOutButton(context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(
        Icons.shopping_cart,
        color: MyColors.myGrey2,
      ),
      label: Text(
        "Check Out",
        style: TextStyle(fontSize: 16, color: MyColors.myGrey2),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(65),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    );
  }
}
