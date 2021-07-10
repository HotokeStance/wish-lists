import 'package:flutter/material.dart';
import 'package:flutter_wish_lists/src/db/wish_item_database.dart';
import 'package:flutter_wish_lists/src/model/wish_item_model.dart';
import 'package:flutter_wish_lists/src/page/input_item_edit_page.dart';

// 詳細ページ
class InputItemDetailPage extends StatefulWidget {
  final int wishItemId;

  const InputItemDetailPage({
    Key? key,
    required this.wishItemId,
  }) : super(key: key);

  @override
  _InputItemDetailPageState createState() => _InputItemDetailPageState();
}

class _InputItemDetailPageState extends State<InputItemDetailPage> {
  late WishItem wishItem;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshWishItems();
  }

  Future refreshWishItems() async {
    setState(() {
      isLoading = true;
    });

    this.wishItem = await WishItemsDatabase.instance.getWishItem(widget.wishItemId);

    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [editButton(), deleteButton()],
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: EdgeInsets.all(12),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 8),
            children: [
              Text(
                wishItem.wishItemName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                wishItem.money.toString(),
                style: TextStyle(color: Colors.white70, fontSize: 18),
              )
            ],
          ),
    )
  );

  Widget editButton() => IconButton(
    icon: Icon(Icons.edit_outlined),
    onPressed: () async {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InputItemEditPage(wishItem: wishItem)));
      refreshWishItems();
    },
  );

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      await WishItemsDatabase.instance.deleteWishItem(widget.wishItemId);

      Navigator.of(context).pop();
    },
  );
}