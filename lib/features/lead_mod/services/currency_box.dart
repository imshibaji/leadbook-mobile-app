import 'package:hive_flutter/hive_flutter.dart';
import '../dbobj/dbobjs.dart';

class CurrencyService {
  static const String boxName = 'currency';
  Box<Currency>? box;

  CurrencyService() {
    init();
  }

  Future init() async {
    box = Hive.box<Currency>(boxName);
  }

  List<Currency> getAll() {
    List<Currency> currencies = box!.values.toList();
    return currencies;
  }

  Future<int> add(Currency currency) async {
    return await box!.add(currency);
  }

  Currency get(int index) {
    return box!.getAt(index)!;
  }

  Future<bool> update(Currency currency) async {
    int index = getAll().indexWhere(
          (element) => element.uid == currency.uid,
    );
    return await updateByIndex(index, currency);
  }

  Future<bool> updateByIndex(int index, Currency currency) async {
    bool isSuccess = false;
    await box!
        .putAt(index, currency)
        .onError((error, stackTrace) => error)
        .whenComplete(() => isSuccess = true);

    return isSuccess;
  }

  Future<bool> delete(int index) async {
    bool isSuccess = false;
    await box!
        .deleteAt(index)
        .onError((error, stackTrace) => error)
        .whenComplete(() => isSuccess = true);

    return isSuccess;
  }
}