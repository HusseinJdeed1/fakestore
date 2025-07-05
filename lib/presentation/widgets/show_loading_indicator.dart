import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class ShowLoadingIndicator extends StatelessWidget {
  const ShowLoadingIndicator({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myBlue,
      ),
    );
  }
}
