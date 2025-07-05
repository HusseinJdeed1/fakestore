import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_strings.dart';

class CategoryItem extends StatelessWidget {
  final int categoryIndex;
  final bool isSelected;
  final List<String> categories;

  const CategoryItem({
    super.key,
    required this.categoryIndex,
    required this.categories,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? MyColors.myBlue
                  : Theme.of(context).colorScheme.surface,
              width: 2.5,
            ),
          ),
          child: ClipOval(
            child: categoryIndex == 0
                ? Icon(
                    Icons.store_mall_directory,
                    color: Theme.of(context).iconTheme.color,
                    size: 30,
                  )
                : FadeInImage.assetNetwork(
                    placeholder: 'assets/images/empty-image.png',
                    image: categoryUrls[categoryIndex - 1],
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          categories[categoryIndex].toUpperCase(),
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontSize: 11),
        ),
      ],
    );
  }
}
