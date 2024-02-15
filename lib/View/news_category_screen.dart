import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Constants/Colors/colors.dart';
import 'package:news_app/Model/categories_news_model/CategoriesNewsModel.dart';
import 'package:news_app/View_Model/news_view_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> categoriesList = <String>[
    "General",
    "Entertainment",
    "Health",
    "Sports",
    "Business",
    "Technology"
  ];
  List<String> categoriesId = <String>[
    "general",
    "entertainment",
    "health",
    "sports",
    "business",
    "technology"
  ];
  String selectedCategory = "General";
  String categoryId = "general";
  final format = DateFormat("MMMM dd,yyyy");
  NewsViewModel newsViewModel = NewsViewModel();

  // int selectedContainerIndex = -1;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: MyColors.compexDrawerCanvasColor,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: MyColors.complexDrawerBlueGrey,
        title: Text("$selectedCategory News"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    Color containerColor = selectedCategory == categoriesList[index]
                        ? MyColors.complexDrawerBlueGrey
                        : MyColors.chargingBlue;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          selectedCategory = categoriesList[index];
                          categoryId = categoriesId[index];
                          // selectedContainerIndex = index;
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                              color: containerColor, borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                categoriesList[index],
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500, fontSize: 13, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoryData(categoryId),
                builder: (context, AsyncSnapshot<CategoriesNewsModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: SpinKitRipple(
                      color: Colors.black54,
                    ));
                  }
                  if (!snapshot.hasData) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(snapshot.error.toString()),
                      ));
                    }
                    return const Center(child: Text("No Data"));
                  } else {
                    return Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.all(10),
                      height: height * .80,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(
                              snapshot.data!.articles![index].publishedAt.toString());
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) {
                                      return const SpinKitFadingCircle(
                                        color: Colors.black,
                                      );
                                    },
                                    fit: BoxFit.fill,
                                    height: height * .18,
                                    width: width * 0.3,
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    errorWidget: (context, url, error) {
                                      return Container(
                                          alignment: Alignment.center,
                                          height: height * .18,
                                          width: width * 0.3,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(color: Colors.black26),
                                              color: Colors.white60),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.error_rounded,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                "Image not found",
                                                style: GoogleFonts.poppins(fontSize: 10),
                                              )
                                            ],
                                          ));
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black26)),
                                    height: height * .18,
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title.toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index].source!.name
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              DateFormat('MMMM dd,yyyy')
                                                  .format(dateTime)
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
