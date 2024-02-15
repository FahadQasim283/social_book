import 'Articles.dart';

class CategoriesNewsModel {
  String? status;
  int? totalResults;
  List<Articles>? articles;

  CategoriesNewsModel({this.status, this.totalResults, this.articles});

  CategoriesNewsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['articles'] != null) {
      articles = <Articles>[];
      json['articles'].forEach((v) {
        articles!.add(new Articles.fromJson(v));
      });
    }
  }
}
