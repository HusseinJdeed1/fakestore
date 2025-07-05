import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../business_logic/cubit/cart_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/product.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/styled_title_text.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  double endIndent = 250;

  late double screenHeight;

  late double screenWidth;

  late bool isAddedToCart;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final cart = BlocProvider.of<CartCubit>(context).userCart;
    isAddedToCart = cart?.products
            ?.any((product) => product.productId == widget.product.id) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: !isAddedToCart
            ? addToCartButton(context)
            : removeFromCartButton(context),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledTitleText(
                  text: "Details",
                  fontSize: 35,
                ),
                ModeToggle(),
              ],
            ),
            Hero(
              tag: widget.product.id,
              child: Image.network(
                height: screenHeight / 1.9,
                widget.product.image,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Text(
                  widget.product.title,
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(8, 5, 8, 0),
                child: Text(
                  "\$ ${widget.product.price.toString()}",
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 5),
              child: Row(
                children: [
                  buildRatingBarIndicator(widget.product.rate.toDouble()),
                  Text(
                    "   (${widget.product.rate.toStringAsFixed(1).toString()})",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontSize: 16),
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.product.description,
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.normal),
                )),
          ],
        ),
      ),
    );
  }

  Widget addToCartButton(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: ElevatedButton.icon(
        onPressed: () {
          BlocProvider.of<CartCubit>(context)
              .addProductToCart(widget.product.id, 1);
          setState(() {
            isAddedToCart = true;
          });
        },
        icon: Icon(
          Icons.shopping_cart,
          color: MyColors.myGrey2,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.myBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(65),
          ),
        ),
        label: Text(
          "Add to Cart",
          style: TextStyle(fontSize: 18, color: MyColors.myGrey2),
        ),
      ),
    );
  }

  Widget removeFromCartButton(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ElevatedButton(
        onPressed: () {
          BlocProvider.of<CartCubit>(context)
              .removeProductFromCart(widget.product.id);
          setState(() {
            isAddedToCart = false;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(65),
          ),
        ),
        child: Text(
          "Remove from Cart",
          style: TextStyle(fontSize: 18, color: MyColors.myGrey2),
        ),
      ),
    );
  }

  buildRatingBarIndicator(double rate) {
    return RatingBarIndicator(
      rating: rate,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: MyColors.myBlue,
      ),
      unratedColor: Theme.of(context).colorScheme.surface,
      itemCount: 5,
      itemSize: 20.0,
      direction: Axis.horizontal,
    );
  }
}
