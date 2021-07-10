import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wish_lists/src/db/wish_item_database.dart';
import 'package:flutter_wish_lists/src/page/input_item_detail_page.dart';
import 'package:flutter_wish_lists/src/page/input_item_edit_page.dart';
import 'package:flutter_wish_lists/src/model/wish_item_model.dart';
import 'package:flutter_wish_lists/src/widget/wish_card_widget.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  late List<WishItem> wishItemsList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshWishItems();
  }

  @override
  Future refreshWishItems() async {
    setState(() {
      isLoading = true;
    });

    debugPrint('wishListが走るよ');

    this.wishItemsList = await WishItemsDatabase.instance.getAllWishItems();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        'Wish List',
      ),
    ),
    body: Center(
      child: isLoading
        ? CircularProgressIndicator()
        : wishItemsList == null || wishItemsList.isEmpty
          ? Text(
        'No Wish Item',
      ): buildWishItems(),
    ),
    floatingActionButton: FloatingActionButton(
      tooltip: 'Increment',
      child: Icon(Icons.add),
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>InputItemEditPage(),)
        )
      },
    ),
  );

  Widget buildWishItems() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: wishItemsList.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final wishItem = wishItemsList[index];

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InputItemDetailPage(wishItemId: wishItem.id!),
          ));
          refreshWishItems();
        },
        child: WishCardWidget(wishItem: wishItem, index: index),
      );
    },
  );
}
