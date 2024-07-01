import 'package:flutter/material.dart';
import 'package:snapify/features/video_saver.dart';
import 'package:snapify/utils/constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor1,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor2,
        ),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Snapify',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.account_circle),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              buildTabBar(),
              Expanded(
                // Use Expanded to allow TabBarView to fill available space
                child: buildContentArea(screenSize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Extracted widgets for better organization
  Widget buildTabBar() {
    return Container(
      color: backgroundColor2,
      child: const TabBar(
        tabs: [
          Tab(text: 'Videos'),
          Tab(text: 'Photos'),
        ],
      ),
    );
  }

  Widget buildContentArea(Size screenSize) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: screenSize.height * 0.4,
            width: screenSize.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(48),
                bottomRight: Radius.circular(48),
              ),
              color: backgroundColor2,
            ),
          ),
        ),
        const TabBarView(
          children: [
            VideoSaver(),
            Placeholder(),
          ],
        ),
      ],
    );
  }
}
