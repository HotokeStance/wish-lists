import 'package:flutter/material.dart';
import 'package:flutter_wish_lists/src/db/wish_item_database.dart';
import 'package:flutter_wish_lists/src/model/wish_item_model.dart';
import 'package:flutter_wish_lists/src/widget/wish_item_form_widget.dart';

// 追加、削除ページ
class InputItemEditPage extends StatefulWidget {
  final WishItem? wishItem;

  const InputItemEditPage({
    Key? key,
    this.wishItem,
  }) : super(key: key);

  @override
  _InputItemState createState() => _InputItemState();
}

class _InputItemState extends State<InputItemEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String wishItemName;
  late String money;

  @override
  void initState() {
    super.initState();

    wishItemName = widget.wishItem?.wishItemName ?? '';
    money = widget.wishItem?.money ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: WishItemFormWidget(
          wishItemName: wishItemName,
          money: money,
          onChangedWishItemName: (wishItemName) => setState(() => this.wishItemName = wishItemName),
          onChangedMoney: (money) => setState(() => this.money = money),
        ),
      )
  );

  Widget buildButton() {
    final isFormValid = wishItemName.isNotEmpty && money.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateWishItem,
        child: Text('保存'),
      ),
    );
  }

  void addOrUpdateWishItem() async {
    final isValid = _formKey.currentState!.validate();
    debugPrint('isValid is ${isValid}');

    if (isValid) {
      final isUpdating = widget.wishItem != null;

      if (isUpdating) {
        await updateWishItem();
      } else {
        await addWishItem();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateWishItem() async {
    final wishItem = widget.wishItem!.copy(
      wishItemName: wishItemName,
      money: money,
    );
    await WishItemsDatabase.instance.updateWishItem(wishItem);
  }

  Future addWishItem() async {
    final wishItem = WishItem(
      wishItemName: wishItemName,
      money: money,
    );
    await WishItemsDatabase.instance.createWishItem(wishItem);
  }
}