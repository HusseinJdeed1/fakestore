import 'package:FakeStore/presentation/screens/account_screen.dart';
import 'package:FakeStore/presentation/screens/cart_screen.dart';
import 'package:FakeStore/presentation/screens/home_page.dart';
import 'package:FakeStore/presentation/screens/login_screen.dart';
import 'package:FakeStore/presentation/screens/product_details_screen.dart';
import 'package:FakeStore/presentation/screens/products_screen.dart';
import 'package:FakeStore/presentation/screens/signup_screen.dart';
import 'package:FakeStore/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic/cubit/cart_cubit.dart';
import 'business_logic/cubit/product_cubit.dart';
import 'business_logic/cubit/user_cubit.dart';
import 'constants/my_strings.dart';
import 'data/models/product.dart';
import 'data/models/user.dart';
import 'data/repository/cart_new_repository.dart';
import 'data/repository/products_repository.dart';
import 'data/repository/users_repository.dart';
import 'data/web_services/cart_web_services.dart';
import 'data/web_services/products_web_services.dart';
import 'data/web_services/users_web_services.dart';

class AppRouter {
  late ProductsRepository productsRepository;
  late UsersRepository usersRepository;
  late CartNewRepository cartNewRepository;
  late ProductCubit productsCubit;
  late UserCubit userCubit;
  late CartCubit cartCubit;
  UserWebServices userWebServices = UserWebServices();
  CartWebServices cartWebServices = CartWebServices();
  AppRouter() {
    productsRepository = ProductsRepository(ProductsWebServices());
    //userRepository = UserLoginRepository(userWebServices);
    // userSignupRepository = UserSignupRepository(userWebServices);
    usersRepository = UsersRepository(userWebServices);
    cartNewRepository = CartNewRepository(cartWebServices);
    productsCubit = ProductCubit(productsRepository);
    userCubit = UserCubit(usersRepository);
    cartCubit = CartCubit(cartNewRepository);
  }
  Route? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case productsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: productsCubit,
            child: ProductsScreen(),
          ),
        );

      case loginScreen:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => MultiBlocProvider(
            providers: [
              BlocProvider<UserCubit>.value(value: userCubit),
              BlocProvider<CartCubit>.value(value: cartCubit),
            ],
            child: LoginScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1200),
        );

      case cartScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => cartCubit,
            child: CartScreen(),
          ),
        );
      case signUpScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: userCubit,
            child: SignupScreen(),
          ),
        );

      case accountScreen:
        final user = setting.arguments as User;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: userCubit,
            child: AccountScreen(user: user),
          ),
        );

      case productDetailsScreen:
        final product = setting.arguments as Product;

        return MaterialPageRoute(
          builder: (context) => BlocProvider<CartCubit>.value(
            value: cartCubit,
            child: ProductDetailsScreen(product: product),
          ),
        );
      case homeScreen:
        final user = setting.arguments as User;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              MultiBlocProvider(
            providers: [
              BlocProvider<ProductCubit>.value(value: productsCubit),
              BlocProvider<UserCubit>.value(value: userCubit),
              BlocProvider<CartCubit>.value(value: cartCubit),
            ],
            child: HomePage(user: user),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1200),
        );

      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<ProductCubit>.value(value: productsCubit),
              BlocProvider<UserCubit>.value(value: userCubit),
              BlocProvider<CartCubit>.value(value: cartCubit),
            ],
            child: SplashScreen(),
          ),
        );
    }
  }
}
