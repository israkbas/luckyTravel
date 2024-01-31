import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lukcytravel/screen/detail_page.dart';

import 'package:lukcytravel/utils/data.dart';
import 'package:lukcytravel/widgets/explore_category_item.dart';
import 'package:lukcytravel/widgets/explore_item.dart';
import 'package:lukcytravel/widgets/icon_box.dart';
import 'package:lukcytravel/widgets/round_textbox.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF7F7F7),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color(0xFFF7F7F7),
              pinned: true,
              snap: true,
              floating: true,
              title: getAppBar(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => buildBody(),
                childCount: 1,
              ),
            )
          ],
        ));
  }

  Widget getAppBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Keşfet",
                style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ],
          )),
          IconBox(
            child: SvgPicture.asset(
              "assets/icons/filter.svg",
              width: 20,
              height: 20,
            ),
          )
        ],
      ),
    );
  }

  buildBody() {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 10,
      ),
      Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: RoundTextBox(
            hintText: "Bul",
            prefixIcon: Icon(Icons.search, color: Color(0xFF3E4249)),
          )),
      SizedBox(
        height: 20,
      ),
      getCategories(),
      SizedBox(
        height: 15,
      ),
      Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: getPlaces(),
      ),
    ]));
  }

  int selectedIndex = 0;

  getCategories() {
    List<Widget> lists = List.generate(
        exploreCategories.length,
        (index) => ExploreCategoryItem(
              data: exploreCategories[index],
              selected: index == selectedIndex,
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
            ));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  getPlaces() {
    return new StaggeredGridView.countBuilder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      itemCount: countries.length,
      itemBuilder: (BuildContext context, int index) => ExploreItem(
        data: countries[index],
        /*   onTap: () {
          // Tıklanma durumunda yapılacak işlemler burada yer alır
          // Örneğin, seçilen ülkenin detay sayfasına yönlendirme yapılabilir
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage()),
          );
        }, */
      ),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 3 : 2),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
    );
  }
}
