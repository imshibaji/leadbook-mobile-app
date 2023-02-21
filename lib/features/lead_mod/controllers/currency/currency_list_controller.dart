import 'package:flutter/material.dart';

import '../../../../architect.dart';
import '../../lead_mod.dart';

class CurrencyListController extends StatelessController {
  const CurrencyListController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Currency Edit',
      mobile: const CurrencyList(),
    );
  }
}
