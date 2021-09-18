import 'package:flutter/material.dart';

class WishItemFormWidget extends StatelessWidget {
  final String? wishItemName;
  final String? money;
  final ValueChanged<String> onChangedWishItemName;
  final ValueChanged<String> onChangedMoney;

  const WishItemFormWidget({
    Key? key,
    this.wishItemName = '',
    this.money = '',
    required this.onChangedWishItemName,
    required this.onChangedMoney,
  }): super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildWishItemName(),
          SizedBox(height: 8),
          buildMoney(),
          SizedBox(height: 16),
        ],
      ),
    ),
  );

  Widget buildWishItemName() => TextFormField(
    maxLines: 1,
    initialValue: wishItemName,
    style: TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: '欲しいもの',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (wishItemName) =>
      wishItemName != null && wishItemName.isEmpty ? '欲しいものを入力してください' : null,
    // autovalidateMode: AutovalidateMode.onUserInteraction,
    onChanged: onChangedWishItemName,
  );

  Widget buildMoney() => TextFormField(
    maxLines: 1,
    initialValue: money,
    style: TextStyle(color: Colors.white60, fontSize: 18),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: '金額',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (money) =>
      money != null && money.isEmpty ? '金額を入力してください' : null,
    // autovalidateMode: AutovalidateMode.onUserInteraction,
    onChanged: onChangedMoney,
  );
}