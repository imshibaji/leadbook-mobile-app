import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../../../core/core.dart';
import '../../../../awesome_notification/awesome_notification_service.dart';
import '../../../dbobj/dbobjs.dart';
import '../../../providers/providers.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class AddDeal extends StatefulWidget {
  const AddDeal({Key? key}) : super(key: key);

  @override
  State<AddDeal> createState() => _AddDealState();
}

class _AddDealState extends State<AddDeal> {
  final GlobalKey<FormState> _dealFormState = GlobalKey<FormState>();
  Lead? lead;
  Deal ideal = Deal();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final sp = context.read<ServiceProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Invoice'),
        actions: actionsMenu(context),
      ),
      bottomNavigationBar: LeadAppBottomBar(),
      body: SizedBox(
        child: Form(
          key: _dealFormState,
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 15,
              ),
              LeadSelectOptionField(
                prefixIcon: Icons.person,
                options: sp.leads,
                selected: null,
                validator: (vlead) {
                  if (vlead != null) {
                    lead = vlead;
                    return null;
                  }
                  return 'Please Choose A Lead';
                },
              ),
              TextInputField(
                prefixIcon: Icons.edit_note,
                labelTextStr: 'Invoice ID',
                validator: (val) {
                  if (val!.isNotEmpty) {
                    ideal.name = val;
                    return null;
                  }
                  return 'Input Invoice ID / Journal Code';
                },
              ),
              TextInputField(
                prefixIcon: Icons.edit_note,
                labelTextStr: 'Invoice Deatils',
                maxLines: 3,
                textInputAction: TextInputAction.done,
                contentPadding: const EdgeInsets.all(9),
                validator: (val) {
                  if (val!.isNotEmpty) {
                    ideal.details = val;
                    return null;
                  }
                  return 'Input Invoice Details';
                },
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextInputField(
                      prefixIcon: Icons.currency_exchange_rounded,
                      labelTextStr: 'Sign',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      contentPadding: const EdgeInsets.all(9),
                      initialValue: '\u{20B9}',
                      validator: (val) {
                        ideal.currencySymbol = val;
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextInputField(
                      prefixIcon: Icons.money,
                      labelTextStr: 'Currency Code',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      contentPadding: const EdgeInsets.all(9),
                      initialValue: 'INR',
                      validator: (val) {
                        ideal.currencyCode = val;
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextInputField(
                      prefixIcon: Icons.edit_note,
                      labelTextStr: 'Amount',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      contentPadding: const EdgeInsets.all(9),
                      validator: (val) {
                        if (val!.isNotEmpty) {
                          ideal.price = double.parse(val);
                          return null;
                        }
                        return 'Input Amount';
                      },
                    ),
                  ),
                  Expanded(
                    child: TextInputField(
                      prefixIcon: Icons.edit_note,
                      labelTextStr: 'Discount',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      contentPadding: const EdgeInsets.all(9),
                      validator: (val) {
                        if (val!.isNotEmpty) {
                          ideal.discount = double.parse(val);
                          return null;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextInputField(
                      prefixIcon: Icons.edit_note,
                      labelTextStr: 'Paid Amount',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      contentPadding: const EdgeInsets.all(9),
                      validator: (val) {
                        if (val!.isNotEmpty) {
                          ideal.paidAmt = double.parse(val);
                          return null;
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextInputField(
                      prefixIcon: Icons.edit_note,
                      labelTextStr: 'Pending Amount',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      contentPadding: const EdgeInsets.all(9),
                      validator: (val) {
                        if (val!.isNotEmpty) {
                          ideal.pendingAmt = double.parse(val);
                          return null;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SelectOptionField(
                prefixIcon: Icons.water_drop_outlined,
                labelTextStr: 'Status',
                options: const [
                  'Pending',
                  'Paid',
                ],
                selected: 'Pending',
                validator: (val) {
                  if (val!.isNotEmpty) {
                    ideal.status = val;
                    return null;
                  }
                  return 'Input Discussion Status';
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: DateInputField(
                      onDateChange: (date) => selectedDate = date,
                    ),
                  ),
                  Expanded(
                    child: TimeInputField(
                      onTimeChange: (time) => selectedTime = time,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  AppButton(
                    label: 'Save Now',
                    onPressed: onDealSubmit,
                    stretch: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDealSubmit() {
    if (_dealFormState.currentState!.validate()) {
      setState(() {});

      // Init
      Lead ilead = lead!;
      Deal ndeal = ideal;
      DateTime createAt = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      ndeal.createdAt = createAt;
      ndeal.leadUid = lead!.uid;
      ndeal.uid = uuid();

      // Add Data in Box
      DealService ds = DealService();
      ds.add(ndeal);

      if (ilead.deals == null) {
        ilead.deals = HiveList(ds.box!);
        ilead.deals!.add(ndeal);
      } else {
        ilead.deals!.add(ndeal);
      }

      // Service Provider Initialized
      final sp = context.read<ServiceProvider>();
      // sp.updateLead(ilead);
      ilead.save();

      sp.getAllDeals();

      showMessage(context, 'New Deal is Added');
      if (ndeal.status!.toLowerCase() == 'paid') {
        dealPaymentAdd(ndeal);
      }
      // Setup Notification
      if (ndeal.status!.toLowerCase() != 'paid') {
        AwesomeNotificationService().showActivityNotification(
          'Proposal / Deal',
          ndeal.details!,
          payload: {
            'mobile': ilead.mobile ?? '',
            'email': ilead.email ?? '',
            'type': 'LEAD',
            'id': ilead.uid ?? ''
          },
          schedule: ndeal.createdAt,
        );
      }

      Nav.close(context);
    }
  }
}
