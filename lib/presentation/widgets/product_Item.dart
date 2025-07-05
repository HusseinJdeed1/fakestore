import 'package:flutter/material.dart';

import '../../constants/my_strings.dart';
import '../../data/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, productDetailsScreen,
                arguments: product);
          },
          child: GridTile(
            footer: Hero(
              tag: product.id,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: Theme.of(context).colorScheme.surface,
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        height: 1.3,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        height: 1.3,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            child: product.image.isNotEmpty
                ? FadeInImage.assetNetwork(
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: "assets/images/empty-image.png",
                    image: product.image,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    "assets/images/empty-image.png",
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ),
    );
  }
}
