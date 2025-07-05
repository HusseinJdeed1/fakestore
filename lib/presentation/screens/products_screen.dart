import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/product_cubit.dart';
import '../../data/models/product.dart';
import '../widgets/category_Item.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/product_Item.dart';
import '../widgets/show_loading_indicator.dart';
import '../widgets/styled_title_text.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late List<Product> showingProducts;
  late List<Product> allProducts;
  bool isSearching = false;
  bool isCategorySelected = false;
  int selectedCategoryIndex = -1;
  final searchTextController = TextEditingController();
  late List<Product> searchedForProducts;
  late List<String> categoryOfProducts = [
    "All",
    "women's clothing",
    "jewelery",
    "men's clothing",
    "electronics"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProductCubit>(context).getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledTitleText(text: "Fake Store", fontSize: 28),
                  ModeToggle(),
                ],
              ),
              buildBlockWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBlockWidget() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          allProducts = state.products;
          showingProducts = allProducts;

          return buildLoadedListWidgets();
        } else {
          return ShowLoadingIndicator();
        }
      },
    );
  }

  buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearchField(),
            StyledTitleText(text: "Categories", fontSize: 16),
            buildCategoriesList(),
            StyledTitleText(text: "All Products", fontSize: 16),
            buildProductList(),
          ],
        ),
      ),
    );
  }

  List<Widget> buildAppBarActions() {
    if (isSearching) {
      return [
        IconButton(
          onPressed: () {
            clearSearch();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: startSearch,
          icon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ];
    }
  }

  void startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(
      LocalHistoryEntry(onRemove: stopSearching),
    );
    setState(() {
      isSearching = true;
    });
  }

  void stopSearching() {
    clearSearch();
    setState(() {
      isSearching = false;
    });
  }

  void clearSearch() {
    setState(() {
      searchTextController.clear();
    });
  }

  buildProductList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.2 / 3,
          crossAxisSpacing: 3,
          mainAxisSpacing: 1),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: showingProducts.length,
      itemBuilder: (ctx, index) {
        return ProductItem(product: showingProducts[index]);
      },
    );
  }

  Widget buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(65),
        color: Theme.of(context).colorScheme.surface,
      ),
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
        controller: searchTextController,
        cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
          ),
          hintText: "search",
          border: OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontSize: 16,
          ),
        ),
        onChanged: (searchedProduct) {
          BlocProvider.of<ProductCubit>(context)
              .getSearchedProducts(searchedProduct);
        },
      ),
    );
  }

  buildCategoriesList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryOfProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (selectedCategoryIndex == index) {
                selectedCategoryIndex = -1;
                isCategorySelected = false;
                BlocProvider.of<ProductCubit>(context).getAllCategorises();
              } else {
                selectedCategoryIndex = index;
                isCategorySelected = true;

                BlocProvider.of<ProductCubit>(context)
                    .getCategorisedProducts(categoryOfProducts[index], index);
              }
              setState(() {});
            },
            child: CategoryItem(
              categoryIndex: index,
              categories: categoryOfProducts,
              isSelected: selectedCategoryIndex == index,
            ),
          );
        },
      ),
    );
  }
}
