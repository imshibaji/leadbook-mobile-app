import 'package:flutter/material.dart';

import '../../../../architect.dart';
import '../../lead_mod.dart';

class CurrencyEditController extends StatelessController {
  const CurrencyEditController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Currency Edit',
      mobile: const CurrencyEdit(),
    );
  }
}
