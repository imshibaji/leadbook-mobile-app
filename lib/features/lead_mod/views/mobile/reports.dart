import 'package:clean_architecture/features/lead_mod/dbobj/payment.dart';
import 'package:clean_architecture/features/lead_mod/widgets/date_range_btn_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../lead_mod.dart';

class ReportsForMobile extends StatefulWidget {
  const ReportsForMobile({Key? key}) : super(key: key);

  @override
  State<ReportsForMobile> createState() => _ReportsForMobileState();
}

class _ReportsForMobileState extends State<ReportsForMobile> {
  List<TargetFocus> tergets = [];

  GlobalKey tabBar = GlobalKey();
  GlobalKey actionsButtons = GlobalKey();
  DateTime currentDate = DateTime.now();
  DateTime previousDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    setDateRange();
  }

  void setDateRange([int days = 30]) {
    setState(() {});
    currentDate = DateTime.now();
    previousDate = currentDate.subtract(Duration(days: days));
  }

  dateTimeRangePicker() async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 1),
        initialDateRange: DateTimeRange(
          end: currentDate,
          start: previousDate,
        ));
    currentDate = picked!.end;
    previousDate = picked.start;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppIcon(),
        title: const Text('Reports'),
        actions: actionsMenu(context),
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, sp, child) {
          var pays = sp.payments;
          var payments = pays!.where((e) {
            return (e.createdAt!.isAfter(previousDate) &&
                e.createdAt!.isBefore(currentDate));
          }).toList();
          return SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                daysGrouppedButtons(),
                LBDateRangeBtnUI(
                  startDate: previousDate,
                  endDate: currentDate,
                  onTap: () {
                    dateTimeRangePicker();
                  },
                ),
                SizedBox(
                  height: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ieCard(
                        color: const Color.fromARGB(255, 3, 236, 154),
                        assetsImageName: 'profits.svg',
                        amount: getTotalIncome(payments).toK(),
                      ),
                      ieCard(
                        title: 'Expenses',
                        color: const Color.fromARGB(255, 254, 147, 147),
                        amount: getTotalExpense(payments).toK(),
                      ),
                    ],
                  ),
                ),
                balanceCard(
                  title: 'Balance:',
                  amount: getBalance(payments).toK(),
                ),
                transectionsList(
                  getTransactionFilter(payments, 'All') as List<Payment>,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: LeadAppBottomBar(key: tabBar),
    );
  }

  Container daysGrouppedButtons() {
    return Container(
      color: Colors.teal.shade400.withAlpha(100),
      padding: const EdgeInsets.all(5),
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ElevatedButton(
            onPressed: () => setDateRange(7),
            child: const Text('7 Days'),
          ),
          ElevatedButton(
            onPressed: () => setDateRange(14),
            child: const Text('14 Days'),
          ),
          ElevatedButton(
            onPressed: () => setDateRange(30),
            child: const Text('30 Days'),
          ),
          ElevatedButton(
            onPressed: () => setDateRange(60),
            child: const Text('60 Days'),
          ),
          ElevatedButton(
            onPressed: () => setDateRange(90),
            child: const Text('90 Days'),
          ),
          ElevatedButton(
            onPressed: () => setDateRange(180),
            child: const Text('180 Days'),
          ),
        ],
      ),
    );
  }

  Widget transectionsList(
    List<Payment> payments, {
    String notFoundTxt = 'No Transection Listed.',
  }) {
    List trans = payments;
    return Expanded(
      child: trans.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: trans.length,
                itemBuilder: (context, index) => listItem(
                  context,
                  trans[index],
                ),
              ),
            )
          : Center(
              child: Text(notFoundTxt),
            ),
    );
  }

  Padding listItem(BuildContext context, Payment payment) {
    var pct = payment.createdAt!;
    var dateTime =
        '${pct.day}/${pct.month}/${pct.year} ${pct.hour}:${pct.minute}';
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatusText(
              label: payment.type ?? 'Income',
              size: 9,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (payment.details ?? 'No Details').substring(
                0,
                (payment.details!.length > 50) ? 5 : payment.details!.length,
              ),
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.left,
            ),
            Text(
              'At: ' + dateTime,
              style: const TextStyle(fontSize: 9),
            ),
          ],
        ),
        shape: Border.all(width: 0.5),
        leading: const Icon(
          Icons.monetization_on_outlined,
          size: 36,
        ),
        trailing: Text(payment.amount.toString()),
        onTap: () {},
      ),
    );
  }

  Row dateRangeUi() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                " From",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DateInputField(
                  initialDate: previousDate,
                  onDateChange: (date) {
                    print(date);
                  }),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                " To",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DateInputField(onDateChange: (date) {
                print(date);
              }),
            ],
          ),
        ),
      ],
    );
  }

  void showTutorial() {}

  // Not Used
  BottomAppBar bottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: AppColors.teal,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  Nav.toReplace(context, LeadApp.home);
                },
                icon: const Icon(
                  Icons.dashboard,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Nav.toReplace(context, LeadApp.listLeads);
                },
                icon: Column(
                  children: const [
                    Icon(Icons.groups_outlined),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Nav.toReplace(context, LeadApp.listDeal);
                },
                icon: const Icon(Icons.payments),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Nav.toReplace(context, LeadApp.transactions);
                },
                icon: const Icon(Icons.account_balance_wallet_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
