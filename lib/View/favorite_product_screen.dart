import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/View/product_detail_screen.dart';
import 'package:news_app/View_Model/product_view_model.dart';
import 'package:pie_chart/pie_chart.dart';

import '../Constants/Colors/colors.dart';

class FavoriteProducts extends StatefulWidget {
  const FavoriteProducts({super.key});

  @override
  State<FavoriteProducts> createState() => _FavoriteProductsState();
}

class _FavoriteProductsState extends State<FavoriteProducts> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Container(
      color: MyColors.complexDrawerBlack,
      child: ProductViewModel.favoriteProducts.isEmpty
          ? Center(
              child: Text(
                "No Favorite Items",
                style: GoogleFonts.poppins(fontSize: 24),
              ),
            )
          : ListView(
              children: List.generate(
                  ProductViewModel.favoriteProducts.length,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              ratingBox(
                                  key: ProductViewModel
                                      .favoriteProducts[index].rating
                                      .toString(),
                                  value: ProductViewModel
                                      .favoriteProducts[index].rating
                                      .toString()),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: SizedBox(
                                  height: height * 0.2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: width * 0.45,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              ProductViewModel
                                                  .favoriteProducts[index].title
                                                  .toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                                style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        FontWeight.w600),
                                                "${ProductViewModel.favoriteProducts[index].price} \$"),
                                          ],
                                        ),
                                      ),
                                      ClipOval(
                                          child: CachedNetworkImage(
                                        height: height * .3,
                                        width: width * 0.4,
                                        fit: BoxFit.fill,
                                        imageUrl: ProductViewModel
                                            .favoriteProducts[index].thumbnail
                                            .toString(),
                                        placeholder: (context, url) =>
                                            const SpinKitFadingCircle(
                                          color: Colors.black,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                alignment: Alignment.center,
                                                height: height * .18,
                                                width: width * 0.3,
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color: Colors.black26),
                                                    color: Colors.white60),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.error_rounded,
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                      "Image not found",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 10),
                                                    )
                                                  ],
                                                )),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                          id: ProductViewModel
                                              .favoriteProducts[index].id
                                              .toString(),
                                          title: ProductViewModel
                                              .favoriteProducts[index].title,
                                          description: ProductViewModel
                                              .favoriteProducts[index]
                                              .description,
                                          image: ProductViewModel
                                              .favoriteProducts[index]
                                              .thumbnail,
                                          price: ProductViewModel
                                              .favoriteProducts[index].price
                                              .toString(),
                                          rating: ProductViewModel
                                              .favoriteProducts[index].rating
                                              .toString(),
                                          category: ProductViewModel
                                              .favoriteProducts[index].category,
                                          brand: ProductViewModel
                                              .favoriteProducts[index].brand
                                              .toString(),
                                          photos: ProductViewModel
                                              .favoriteProducts[index].images,
                                        ),
                                      ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: MyColors.lockerColors1),
                                  padding: const EdgeInsets.all(10),
                                  child: const Center(child: Text("Details")),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
            ),
    );
  }

  Widget ratingBox({key, value}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: MyColors.lockerColors1,
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        subtitle: PieChart(
            chartLegendSpacing: 10,
            animationDuration: const Duration(milliseconds: 1500),
            chartRadius: 70,
            chartType: ChartType.ring,
            colorList: [Colors.green.shade500, MyColors.headLightRed],
            legendOptions: const LegendOptions(
              legendPosition: LegendPosition.top,
              showLegendsInRow: true,
            ),
            chartValuesOptions:
                const ChartValuesOptions(showChartValuesInPercentage: true),
            dataMap: {"Total": 5, "Current ": double.parse(value)}),
        title: Text(
          "Rating : $value",
          style: GoogleFonts.poppins(),
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}
