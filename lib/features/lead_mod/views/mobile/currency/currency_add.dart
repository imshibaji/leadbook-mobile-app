import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class CurrencyAdd extends StatefulWidget {
  const CurrencyAdd({Key? key}) : super(key: key);

  @override
  State<CurrencyAdd> createState() => _CurrencyAddState();
}

class _CurrencyAddState extends State<CurrencyAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Add'),
        actions: actionsMenu(context),
      ),
      body: SizedBox(
        width: double.infinity,
        height: 800,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Base Currency Details",
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextInputField(
                      prefixIcon: Icons.money,
                      labelTextStr: 'Code',
                      initialValue: 'INR',
                      validator: (value) {
                        if (value!.isNotEmpty) {}
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextInputField(
                      prefixIcon: Icons.monetization_on_outlined,
                      labelTextStr: 'Symbol',
                      initialValue: 'Rs',
                      validator: (value) {
                        if (value!.isNotEmpty) {}
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextInputField(
                      prefixIcon: Icons.monetization_on_outlined,
                      labelTextStr: 'Value',
                      initialValue: '1',
                      validator: (value) {
                        if (value!.isNotEmpty) {}
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 3,
              ),
              const Text(
                "Conversion Currency Details",
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextInputField(
                      prefixIcon: Icons.money,
                      labelTextStr: 'Code',
                    ),
                  ),
                  Expanded(
                    child: TextInputField(
                      prefixIcon: Icons.monetization_on_outlined,
                      labelTextStr: 'Symbol',
                    ),
                  ),
                ],
              ),
              TextInputField(
                prefixIcon: Icons.monetization_on_outlined,
                labelTextStr: 'Amount Value',
              ),
              const Divider(
                thickness: 4,
              ),
              Row(
                children: [
                  Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                  const Text('Default currency?')
                ],
              ),
              Row(
                children: [
                  AppButton(
                    label: 'Save',
                    onPressed: () {},
                    stretch: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
