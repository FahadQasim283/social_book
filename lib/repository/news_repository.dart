// ignore_for_file: empty_catches
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/Model/categories_news_model/CategoriesNewsModel.dart';
import '../Model/news_channel_headlines_model/news_channel_headlines_model.dart';

class NewsRepository {
  final String _apiKey = "906664a289d446fd961d2beb72598c90";

  Future<NewsChannelHeadlinesModel> fetchNewsHeadlinesData(
      String channelName) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=$_apiKey'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return NewsChannelHeadlinesModel.fromJson(data);
    }
    throw ("${response.reasonPhrase}\n\nStatus : ${data["status"]}\nCode : ${data["code"]}\nMessage${data['message']}");
  }

  Future<CategoriesNewsModel> fetchCategoryData(String category) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=$category&apiKey=$_apiKey'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return CategoriesNewsModel.fromJson(data);
    }
    throw ("${response.reasonPhrase}\n\nStatus : ${data["status"]}\nCode : ${data["code"]}\nMessage : ${data['message']}");
  }
}
