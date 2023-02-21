import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';
import '../../dbobj/dbobjs.dart';
import '../../lead_mod.dart';

class DashboardForMobile extends StatefulWidget {
  const DashboardForMobile({Key? key}) : super(key: key);

  @override
  State<DashboardForMobile> createState() => _DashboardForMobileState();
}

class _DashboardForMobileState extends State<DashboardForMobile> {
  List<TargetFocus> tergets = [];
  Business? business;
  Profile? profile;
  String shareInfoData = 'Share your contact Informations quickly';
  GlobalKey tabBar = GlobalKey();
  GlobalKey actionsButtons = GlobalKey();

  dataConsume(ServiceProvider sp) {
    business = sp.business;
    profile = sp.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppIcon(),
        title: const Text('Dashboard'),
        actions: actionsMenu(context, preActions: [
          IconButton(
            onPressed: () {
              shareDialogBox(context);
            },
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          )
        ]),
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, sp, child) {
          dataConsume(sp);
          var leads = sp.leads ?? [];
          var followups = sp.followups ?? [];
          var deals = sp.deals ?? [];
          var pays = sp.payments ?? [];
          var firstDayofMoth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          var payments = pays
              .where(
                (element) => firstDayofMoth.isBefore(element.createdAt!),
              )
              .toList();

          return SizedBox(
            width: double.infinity,
            child: ListView(
              children: [
                balanceCard(
                  title: 'Balance:',
                  subtitle: 'Total',
                  amount: getBalance(pays).toK(),
                  onTap: () {
                    Nav.goTo("/reports");
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
                          title: 'Income',
                          subtitle: 'This Month',
                          onTap: () {
                            Nav.goTo("/reports");
                          },
                        ),
                        ieCard(
                          title: 'Expenses',
                          subtitle: 'This Month',
                          color: const Color.fromARGB(255, 254, 147, 147),
                          amount: getTotalExpense(payments).toK(),
                          onTap: () {
                            Nav.goTo("/reports");
                          },
                        ),
                      ],
                    )),
                shortcutButton(
                  title: 'All Leads',
                  pins: leads.isNotEmpty ? leads.length : 0,
                  onPress: () {
                    Nav.to(context, LeadApp.listLeads);
                  },
                ),
                shortcutButton(
                  prefixIcon: Icons.attractions_outlined,
                  color: const Color.fromARGB(255, 247, 141, 3),
                  title: 'Followups / Activities',
                  pins: followups.isNotEmpty ? followups.length : 0,
                  onPress: () {
                    Nav.to(context, LeadApp.followup);
                  },
                ),
                shortcutButton(
                  prefixIcon: Icons.handshake_rounded,
                  color: Colors.blueGrey,
                  title: 'Deals / Proposals',
                  pins: deals.isNotEmpty ? deals.length : 0,
                  onPress: () {
                    Nav.to(context, LeadApp.listDeal);
                  },
                ),
                shortcutButton(
                  prefixIcon: Icons.accessibility_new,
                  color: const Color.fromARGB(255, 31, 151, 95),
                  title: 'Converted Leads',
                  pins: leads.isNotEmpty
                      ? leads
                          .where((element) =>
                              element.status!.toLowerCase() == 'success')
                          .toList()
                          .length
                      : 0,
                  onPress: () {
                    if (leads
                        .where((element) =>
                            element.status!.toLowerCase() == 'success')
                        .toList()
                        .isNotEmpty) {
                      Nav.go(LeadApp.listLeads, arguments: 'success');
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: LeadAppBottomBar(key: tabBar),
    );
  }

  Future<dynamic> shareDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informations'),
        contentPadding: const EdgeInsets.all(20),
        content: Text(shareInfoData),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsOverflowAlignment: OverflowBarAlignment.center,
        actionsPadding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 8,
          top: 0,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (business != null) {
                var data =
                    '${business!.name!}, Address: ${business!.address!}, ${business!.city!},${business!.state!},${business!.country!},${business!.pincode!}, Phone:${business!.phone!}, Alt Phone: ${business!.altPhone ?? 'None'}, Email:${business!.email!}, Website: ${business!.website ?? 'No Website'} - Shared By LeadBook';
                Share.share(data);
              }
            },
            child: const Text('Business'),
          ),
          ElevatedButton(
            onPressed: () {
              if (profile != null) {
                var data =
                    '${profile!.name!}, Mobile: ${profile!.mobile ?? 'No Number'}, Email: ${profile!.email ?? 'No Email'}, Website: ${profile!.website ?? 'No Website'} - Shared By LeadBook';
                Share.share(data);
              }
            },
            child: const Text('Personal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (profile != null) {
                var data =
                    'A/C Holder: ${profile!.bankAccountHolder ?? profile!.name!}, A/C Number: ${profile!.bankAccountNumber ?? 'No Number'}, IFSC/RTGS: ${profile!.bankIfsc ?? 'No IFSC Code'}, UPI Code: ${profile!.upiCode ?? 'No UPI Code'} - Shared By LeadBook';
                Share.share(data);
              }
            },
            child: const Text('Payment'),
          ),
        ],
      ),
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
