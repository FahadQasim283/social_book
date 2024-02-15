import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import '../Constants/Colors/colors.dart';

class ProductDetails extends StatefulWidget {
  final String? id;
  final String? title;
  final String? price;
  final String? description;
  final String? category;
  final String? image;
  final String? rating;
  final List<dynamic>? photos;
  final String? brand;

  const ProductDetails(
      {super.key,
      this.id,
      this.title,
      this.price,
      this.description,
      this.category,
      this.image,
      this.rating,
      this.brand,
      this.photos});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lockerColors2,
        title: Text(widget.title.toString()),
        centerTitle: true,
      ),
      backgroundColor: MyColors.complexDrawerBlack,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                productImageView(context, widget.image.toString());
              },
              child: SizedBox(
                height: height * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    fit: BoxFit.fill,
                    widget.image.toString(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.024,
            ),
            Container(
              decoration: BoxDecoration(
                  color: MyColors.compexDrawerCanvasColor,
                  borderRadius: BorderRadius.circular(12)),
              height: height * .18,
              width: width * 0.17,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    widget.photos!.length,
                    (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              productImageView(
                                  context, widget.photos![index].toString());
                            },
                            child: Container(
                              width: width * 0.6,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(12)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: widget.photos![index].toString(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                  placeholder: (context, url) =>
                                      const SpinKitFadingCircle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
            ),
            Column(
              children: [
                useableBox(key: "Product ID:", value: widget.id),
                useableBox(key: "Product :", value: widget.title),
                useableBox(key: "Description :", value: widget.description),
                useableBox(key: "Category :", value: widget.category),
                useableBox(key: "Brand :", value: widget.brand),
                useableBox(key: "Price :", value: "${widget.price} \$"),
                ratingBox(
                  key: "Rating :",
                  value: widget.rating,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  productImageView(context, String image) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Card(
          child: InteractiveViewer(
            child: Image.network(image),
          ),
        );
      },
    );
  }

  Widget useableBox({key, value}) {
    return Card(
      color: MyColors.compexDrawerCanvasColor,
      child: ListTile(
        leading: Text(
          key.toString(),
        ),
        title: Text(
          value.toString(),
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  Widget ratingBox({key, value}) {
    return Card(
      color: MyColors.compexDrawerCanvasColor,
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
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}
