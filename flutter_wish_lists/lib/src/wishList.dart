import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wish_lists/src/db/wish_item_database.dart';
import 'package:flutter_wish_lists/src/page/input_item_detail_page.dart';
import 'package:flutter_wish_lists/src/page/input_item_edit_page.dart';
import 'package:flutter_wish_lists/src/model/wish_item_model.dart';
import 'package:flutter_wish_lists/src/widget/wish_card_widget.dart';
import 'package:flutter/src/widgets/routes.dart';
import 'package:intl/intl.dart';

class WishList extends StatefulWidget {
  final RouteObserver<PageRoute> routeObserver;
  const WishList({Key? key, required this.routeObserver}) :super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> with RouteAware {
  late List<WishItem> wishItemsList;
  bool isLoading = false;
  int wishItemCount = 0;
  String wishItemTotalMoney = '0';


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // 一度、別の画面に遷移したあとで、再度この画面に戻ってきた時にコールされる。
    refreshWishItems();
  }

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

    this.wishItemsList = await WishItemsDatabase.instance.getAllWishItems();
    returnItemLength();
    calcWishItemsTotalMoney();

    setState(() {
      isLoading = false;
    });
  }

  // リストの長さを返す
  @override
  returnItemLength() {
    int result = 0;
    if (this.wishItemsList != null && this.wishItemsList.isNotEmpty) {
      result = this.wishItemsList.length;
    }
    this.wishItemCount = result;
  }

  // 金額を3桁区切りにする
  @override
  moneyFormat(int money) {
    final formatter = NumberFormat("#,###");
    int castMoney = money;
    return formatter.format(castMoney);
  }

  // 欲しいものリストの合計金額を返す
  @override
  calcWishItemsTotalMoney() {
    int totalMoney = 0;
    String result = '';
    if (this.wishItemsList != null && this.wishItemsList.isNotEmpty) {
      for (var i = 0; i < this.wishItemsList.length; i ++) {
        totalMoney += int.parse(this.wishItemsList[i].money);
      }
       result = moneyFormat(totalMoney);
    }
    this.wishItemTotalMoney = result;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        'Wish List',
      ),
    ),
    body: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'アイテム数: ${wishItemCount.toString()}',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            '合計金額: ${wishItemTotalMoney}',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Expanded(
              child: isLoading ? CircularProgressIndicator() : wishItemsList == null || wishItemsList.isEmpty ?
                  Text(
                    'No Wish Items',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ) : buildWishItems(),
          ),
        ],
      ),
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
