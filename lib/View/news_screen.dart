import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Constants/Colors/colors.dart';
import 'package:news_app/Model/news_channel_headlines_model/news_channel_headlines_model.dart';
import 'package:news_app/View/news_category_screen.dart';
import 'package:news_app/View_Model/news_view_model.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

var selectedMenu;
String channelName = "bbc-news";

class _NewsPageState extends State<NewsPage> {
  NewsViewModel newsViewModel = NewsViewModel();
  Faker fakeData = Faker();
  String title = "BBC";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      backgroundColor: MyColors.compexDrawerCanvasColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 5.0,
        backgroundColor: MyColors.complexDrawerBlueGrey,
        actions: [
          PopupMenuButton(
            tooltip: "Channels",
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
            icon: const Icon(Icons.tv),
            constraints: BoxConstraints(maxHeight: height * 0.45, maxWidth: width * 0.60),
            onSelected: (item) {
              NewsViewModel.newsChannelMap.forEach((key, value) {
                if (value == item) {
                  channelName = value;
                  selectedMenu = key;
                  title = value;
                  setState(() {});
                }
              });
            },
            elevation: 5,
            shadowColor: Colors.black26,
            initialValue: selectedMenu,
            itemBuilder: (context) {
              return NewsViewModel.newsChannelMap.entries
                  .map(
                    (entry) => PopupMenuItem(
                      textStyle: GoogleFonts.poppins(color: Colors.black),
                      value: entry.value,
                      child: Text(entry.key),
                    ),
                  )
                  .toList();
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.tab_outlined),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const CategoryScreen()));
          },
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: FutureBuilder<NewsChannelHeadlinesModel>(
          future: newsViewModel.fetchNewsHeadlinesData(channelName.toString()),
          builder: (context, AsyncSnapshot<NewsChannelHeadlinesModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SpinKitRipple(
                color: Colors.black54,
              ));
            } else if (!snapshot.hasData) {
              if (snapshot.hasError) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(snapshot.error.toString()),
                ));
              } else {
                return const Center(child: Text("No Data"));
              }
            } else {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.articles!.length,
                itemBuilder: (context, index) {
                  DateTime dateTime =
                      DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                  return SizedBox(
                    height: height * .3,
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.30,
                          width: width * 0.990,
                          padding: EdgeInsets.symmetric(
                              horizontal: height * 0.02, vertical: height * 0.01),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: snapshot.data!.articles![index].urlToImage!,
                              placeholder: (context, url) {
                                return const SpinKitFadingCircle(
                                  color: Colors.black,
                                );
                              },
                              errorWidget: (context, url, error) {
                                return const Center(
                                  child: Text("Image Load Error"),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              width: width * 0.9,
                              child: Column(
                                children: [
                                  Text(
                                    snapshot.data!.articles![index].title.toString(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: height * .01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(snapshot.data!.articles![index].source!.name.toString(),
                                          style: GoogleFonts.poppins(color: Colors.blue)),
                                      Text(
                                        DateFormat('MMMM dd,yyyy').format(dateTime).toString(),
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black26,
                                  ),
                                  SizedBox(
                                    height: height * .01,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: height * 0.40,
                                      child: ListView(
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index].description.toString(),
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600, fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: height * .02,
                                          ),
                                          Text(
                                            "${snapshot.data!.articles![index].content}\n\n${fakeData.randomGenerator.fromCharSet(snapshot.data!.articles![index].description.toString(), 1000)}",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500, fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

/* ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: height * 0.6,
                              width: width * 0.990,
                              padding: EdgeInsets.symmetric(
                                  horizontal: height * 0.02,
                                  vertical: height * 0.01),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage!,
                                    placeholder: (context, url) {
                                      return const SpinKitFadingCircle(
                                        color: Colors.black,
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return const Center(
                                        child: Text("Image Load Error"),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  height: height * 0.20,
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: height * .1,
                                        width: width * .7,
                                        child: Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      // const Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue),
                                          ),
                                          Text(
                                            DateFormat('MMMM dd,yyyy')
                                                .format(dateTime)
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )*/
/*
* Padding(
            padding: const EdgeInsets.all(12),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoryData("general"),
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
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.all(10),
                    height: height * .80,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
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
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  errorWidget: (context, url, error) {
                                    return Container(
                                        alignment: Alignment.center,
                                        height: height * .18,
                                        width: width * 0.3,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                              style: GoogleFonts.poppins(
                                                  fontSize: 10),
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
                                      border:
                                          Border.all(color: Colors.black26)),
                                  height: height * .18,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
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
          )*/
