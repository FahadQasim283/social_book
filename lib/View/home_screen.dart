import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/View/market_screen.dart';
import 'package:news_app/View/news_screen.dart';

import '../Constants/Colors/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<IconData> icons = [
    CupertinoIcons.house_alt,
    CupertinoIcons.person_2,
    CupertinoIcons.bubble_right,
    CupertinoIcons.bell,
    Icons.newspaper,
    CupertinoIcons.cart,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          backgroundColor: MyColors.complexDrawerBlueGrey,
          foregroundColor: Colors.white,
          bottom: Tab(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    icons.length,
                    (index) => IconButton(
                        onPressed: () {
                          switch (index) {
                            case 0:
                              {}
                            case 1:
                              {}

                            case 2:
                              {}
                            case 3:
                              {}
                            case 4:
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NewsPage(),
                                    ));
                              }
                            case 5:
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MarketPage(),
                                    ));
                              }
                          }
                        },
                        icon: Icon(
                          icons[index],
                          color: Colors.white,
                        )))),
          ),
        ));
  }
}

class MyIconButton extends StatelessWidget {
  final VoidCallback ontap;
  final IconData? icon;
  final Color? color;

  const MyIconButton({super.key, this.color, required this.ontap, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ontap,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
          child: Icon(icon!, color: Colors.white),
        ));
  }
}
