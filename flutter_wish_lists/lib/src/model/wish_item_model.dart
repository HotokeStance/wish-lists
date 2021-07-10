import 'package:flutter/foundation.dart';

final String tableWishItems = 'WishItemsTable';

class WishItemFields {
  static final List<String> values = [
    id,
    wishItemName,
    money,
  ];

  static final String id = '_id';
  static final String wishItemName = '_wishItemName';
  static final String money = '_money';
}

class WishItem {
  final int? id;
  final String wishItemName;
  final String money;

  const WishItem({
    this.id,
    required this.wishItemName,
    required this.money,
  });

  WishItem copy({
    int? id,
    String? wishItemName,
    String? money,
  }) => WishItem(id: id ?? this.id, wishItemName: wishItemName ?? this.wishItemName, money: money ?? this.money);

  static WishItem fromJson(Map<String, Object?> json) => WishItem(
      id: json[WishItemFields.id] as int?,
      wishItemName: json[WishItemFields.wishItemName] as String,
      money: json[WishItemFields.money] as String,
  );

  Map<String, Object?> toJson() => {
    WishItemFields.id: id,
    WishItemFields.wishItemName: wishItemName,
    WishItemFields.money: money,
  };
}