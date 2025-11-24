import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionItemModel extends HiveObject {
  @HiveField(0)
  late String productId;

  @HiveField(1)
  late String productName;

  @HiveField(2)
  late double price;

  @HiveField(3)
  late int quantity;

  TransactionItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });
}

@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime dateTime;

  @HiveField(2)
  late double totalAmount;

  @HiveField(3)
  late List<TransactionItemModel> items;

  TransactionModel({
    required this.id,
    required this.dateTime,
    required this.totalAmount,
    required this.items,
  });
}
