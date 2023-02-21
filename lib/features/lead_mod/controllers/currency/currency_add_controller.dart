import 'package:flutter/material.dart';

import '../../../../architect.dart';
import '../../lead_mod.dart';

class CurrencyAddController extends StatelessController {
  const CurrencyAddController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Currency Add',
      mobile: const CurrencyAdd(),
    );
  }
}
