import 'package:hive/hive.dart';
import 'package:leadbook_mobile_app/hive_helper/hive_types.dart';
import 'package:leadbook_mobile_app/hive_helper/hive_adapters.dart';
import 'package:leadbook_mobile_app/hive_helper/fields/currency_fields.dart';


part 'currency.g.dart';


@HiveType(typeId: HiveTypes.currency, adapterName: HiveAdapters.currency)
class Currency extends HiveObject{
	@HiveField(CurrencyFields.id)
  String? id;
	@HiveField(CurrencyFields.uid)
  String? uid;
	@HiveField(CurrencyFields.name)
  String? name;
	@HiveField(CurrencyFields.code)
  String? code;
	@HiveField(CurrencyFields.symbol)
  String? symbol;
	@HiveField(CurrencyFields.rate)
  double? rate;
	@HiveField(CurrencyFields.base)
  bool? base;
}