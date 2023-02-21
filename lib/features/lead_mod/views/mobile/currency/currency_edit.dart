import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class CurrencyEdit extends StatefulWidget {
  const CurrencyEdit({Key? key}) : super(key: key);

  @override
  State<CurrencyEdit> createState() => _CurrencyEditState();
}

class _CurrencyEditState extends State<CurrencyEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Edit'),
        actions: actionsMenu(context),
      ),
    );
  }
}
