import 'package:FakeStore/presentation/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../business_logic/cubit/cart_cubit.dart';
import '../../data/models/user.dart';
import '../widgets/no_internet_widget.dart';
import '../widgets/show_loading_indicator.dart';
import 'account_screen.dart';
import 'cart_screen.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<CartCubit>(context).loadCartFromLocal();
  }

  int currentSelectedScreenIndex = 1;
  @override
  Widget build(BuildContext context) {
    final List<Widget> screensList = [
      AccountScreen(user: widget.user),
      ProductsScreen(),
      CartScreen(),
    ];

    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).iconTheme.color,
        currentIndex: currentSelectedScreenIndex,
        onTap: (selectedScreenIndex) {
          setState(() {
            currentSelectedScreenIndex = selectedScreenIndex;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                int cartCount = 0;
                if (state is CartLoaded && state.userCart.products != null) {
                  cartCount = state.userCart.products!.length;
                }
                return Badge(
                  label: Text(cartCount.toString()),
                  isLabelVisible: cartCount > 0,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.shopping_cart),
                );
              },
            ),
            label: 'Cart',
          ),
        ],
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          List<ConnectivityResult> connectivity,
          Widget child,
        ) {
          final bool connected =
              !connectivity.contains(ConnectivityResult.none);
          if (connected) {
            return screensList[currentSelectedScreenIndex];
          } else {
            return NoInternetWidget();
          }
        },
        child: ShowLoadingIndicator(),
      ),
    ));
  }
}
