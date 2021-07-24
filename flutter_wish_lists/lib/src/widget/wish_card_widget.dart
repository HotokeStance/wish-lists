import 'package:flutter/material.dart';
import 'package:flutter_wish_lists/src/model/wish_item_model.dart';
import 'package:intl/intl.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class WishCardWidget extends StatelessWidget {

  final WishItem wishItem;
  final int index;

  const WishCardWidget({Key? key, required this.wishItem, required this.index}) : super(key: key);

  // 金額を3桁区切りにする
  moneyFormat(money) {
    final formatter = NumberFormat("#,###");
    var castMoney = int.parse(money);
    return formatter.format(castMoney).toString();
  }

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final minHeight = 100.0;

    return Card(
      color: color,
      child: Container(
        // カードのサイズ
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wishItem.wishItemName != null ? wishItem.wishItemName: '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              wishItem.money.toString() != null ? moneyFormat(wishItem.money.toString()) : '',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
