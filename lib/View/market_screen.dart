import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/View/favorite_product_screen.dart';
import 'package:news_app/View/product_detail_screen.dart';
import 'package:news_app/View_Model/product_view_model.dart';

import '../Constants/Colors/colors.dart';
import '../Model/product_model/product_model.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  double? width;
  double? height;
  ProductViewModel productViewModel = ProductViewModel();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width * 1;
    height = MediaQuery.sizeOf(context).height * 1;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const Drawer(),
        backgroundColor: MyColors.compexDrawerCanvasColor,
        appBar: AppBar(
          title: Text(
            "Market Place",
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          backgroundColor: MyColors.complexDrawerBlueGrey,
          foregroundColor: Colors.white,
          elevation: 1,
          bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.amber,
              tabs: [
                Tab(
                  child: Text("All"),
                ),
                Tab(
                  child: Text("Favorite"),
                ),
                Tab(
                  child: Text("Cart"),
                )
              ]),
        ),
        body: TabBarView(children: [
          productView(),
          const FavoriteProducts(),
          Center(
            child: Text("Cart"),
          ),
        ]),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () => Navigator.pop(context),
            label: Text(
              "Back",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black),
            )),
      ),
    );
  }

  Widget productView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          height: height! * .060,
          width: width!,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today's Picks"),
              Text("Kamra 34 km"),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<ProductModel>(
              future: productViewModel.fetchProductData(),
              builder: (context, AsyncSnapshot<ProductModel> snapshot) {
                if (ConnectionState.waiting == snapshot.connectionState) {
                  return const Center(
                      child: SpinKitRipple(
                    color: Colors.black54,
                  ));
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error"),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Data"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.products!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: MyColors.lockerColors1,
                              border: Border.all(color: Colors.black26),
                              borderRadius: BorderRadius.circular(10)),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                      title: snapshot.data!.products![index].title.toString(),
                                      id: snapshot.data!.products![index].id.toString(),
                                      brand: snapshot.data!.products![index].brand.toString(),
                                      category: snapshot.data!.products![index].category.toString(),
                                      description:
                                          snapshot.data!.products![index].description.toString(),
                                      image: snapshot.data!.products![index].thumbnail.toString(),
                                      price: snapshot.data!.products![index].price.toString(),
                                      rating: snapshot.data!.products![index].rating.toString(),
                                      photos: snapshot.data!.products![index].images,
                                    ),
                                  ));
                            },
                            child: Column(
                              children: [
                                Stack(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      height: height! * 0.3,
                                      imageUrl:
                                          snapshot.data!.products![index].thumbnail.toString(),
                                      placeholder: (context, url) {
                                        return const SpinKitFadingCircle(
                                          color: Colors.white,
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Center(
                                          child: Text(
                                            "Image Load "
                                            "Error : ${error.toString()}",
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Text("${snapshot.data!.products![index].price} \$",
                                        style: GoogleFonts.poppins(color: Colors.amber.shade900)),
                                  )
                                ]),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        myButton(
                                          label: "Add to Cart",
                                          onTap: () {},
                                        ),
                                        myButton(
                                          label: "Add to Favorite",
                                          onTap: () {
                                            ProductViewModel.favoriteProducts
                                                .add(snapshot.data!.products![index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget myButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: MyColors.buttonExampleCanvas),
        child: Text(label),
      ),
    );
  }
}
