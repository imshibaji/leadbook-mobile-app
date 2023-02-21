import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../architect.dart';
import '../../../lead_mod.dart';

class CurrencyList extends StatefulWidget {
  const CurrencyList({Key? key}) : super(key: key);

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  ThemeProvider? tm;

  @override
  Widget build(BuildContext context) {
    tm = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency List'),
        actions: actionsMenu(context),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          Nav.to(context, LeadApp.addCurrency);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          baseCurrencyDetails(),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => ListTile(
                leading: const Text('₹',
                    style: TextStyle(
                      fontSize: 32,
                    )),
                title: const Text('INR - USD'),
                subtitle: const Text('Conv.Rate: 1 = 78.0998'),
                trailing: IconButton(
                  onPressed: () {
                    editDialog(context);
                  },
                  icon: const Icon(Icons.more_horiz),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> editDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit'),
        content: SizedBox(
          height: 178,
          child: Column(
            children: [
              TextInputField(
                prefixIcon: Icons.money,
                labelTextStr: 'Currency Code',
                initialValue: 'USD',
                readOnly: true,
              ),
              TextInputField(
                prefixIcon: Icons.money,
                labelTextStr: 'Conv. Value',
                initialValue: '78.0998',
              ),
              Row(
                children: [
                  Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                  const Text('Set Default')
                ],
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_forever),
          )
        ],
      ),
    );
  }

  Widget baseCurrencyDetails() {
    return Container(
      color: (tm!.themeMode == ThemeMode.dark)
          ? const Color.fromARGB(255, 1, 60, 39)
          : Colors.amber,
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          const Text(
            'Base Currency',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Code: INR', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Symbol: ₹', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Covertion Rate: 1 = 1',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  TableRow tableHeader() {
    return const TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Center(
            child: Text('Code', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Center(
            child:
                Text('Symbol', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Center(
            child: Text('Conv. Rate',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Center(
            child:
                Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
