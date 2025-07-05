import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/no-internet.png",
              fit: BoxFit.fill,
            ),
            SizedBox(height: 5),
            Text(
              "No internet connection",
              style: TextStyle(
                fontSize: 22,
                color: MyColors.myWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
