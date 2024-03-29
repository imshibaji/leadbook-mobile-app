import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/core.dart';
import '../../dbobj/dbobjs.dart';
import '../../services/services.dart';
import '../../utils/backup_restore.dart';

class OwnerProfileMobileView extends StatefulWidget {
  const OwnerProfileMobileView({Key? key}) : super(key: key);

  @override
  State<OwnerProfileMobileView> createState() => _OwnerProfileMobileViewState();
}

class _OwnerProfileMobileViewState extends State<OwnerProfileMobileView> {
  final GlobalKey<FormState> _form = GlobalKey();
  ProfileService? ps;
  Profile? profile;

  String? imgPath;
  bool seePass = true;

  @override
  void initState() {
    super.initState();
    ps = ProfileService();
    if (ps!.box!.isNotEmpty) {
      if (profile == null) {
        setState(() {
          profile = ps!.get(0);
          // log(business.toString());
        });
      }
    } else {
      profile = Profile();
      ps!.add(profile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Profile'),
        actions: actionsMenu(context),
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8),
              //   child: InkWell(
              //     onTap: () {
              //       // Image Uploader Function
              //     },
              //     child: CircleAvatar(
              //       child: (imgPath == null)
              //           ? const Text('🙂')
              //           : Image.file(File(imgPath!)),
              //       radius: 60,
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              TextInputField(
                labelTextStr: 'Name',
                prefixIcon: Icons.person,
                initialValue: profile!.name,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isNotEmpty) {
                    profile!.name = val;
                    return null;
                  }
                  return 'Please Input Name';
                },
              ),
              TextInputField(
                labelTextStr: 'Mobile',
                prefixIcon: Icons.call,
                keyboardType: TextInputType.phone,
                initialValue: profile!.mobile,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isNotEmpty) {
                    profile!.mobile = val;
                    return null;
                  }
                  return 'Input your Mobile Number';
                },
              ),
              TextInputField(
                labelTextStr: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                initialValue: profile!.email,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isNotEmpty) {
                    profile!.email = val;
                    return null;
                  }
                  return 'Input Your Email';
                },
              ),
              TextInputField(
                labelTextStr: 'Website',
                prefixIcon: Icons.web,
                initialValue: profile!.website ?? '',
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isNotEmpty) {
                    profile!.website = val;
                  }
                  return null;
                },
              ),

              const Divider(),
              const Center(child: Text('Bank Account Information')),
              const Divider(),
              //Bank Account Details
              TextInputField(
                labelTextStr: 'A/C Holder',
                prefixIcon: Icons.person,
                initialValue: profile!.bankAccountHolder ?? '',
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isNotEmpty) {
                    profile!.bankAccountHolder = val;
                  }
                  return null;
                },
              ),
              TextInputField(
                labelTextStr: 'A/C Number',
                prefixIcon: Icons.numbers,
                initialValue: profile!.bankAccountNumber ?? '',
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isNotEmpty) {
                    profile!.bankAccountNumber = val;
                  }
                  return null;
                },
              ),
              TextInputField(
                labelTextStr: 'IFSC / RTGS',
                prefixIcon: Icons.person,
                initialValue: profile!.bankIfsc ?? '',
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isNotEmpty) {
                    profile!.bankIfsc = val;
                  }
                  return null;
                },
              ),
              TextInputField(
                labelTextStr: 'UPI Code / Payment Code',
                prefixIcon: Icons.info,
                initialValue: profile!.upiCode ?? '',
                textInputAction: TextInputAction.done,
                validator: (val) {
                  if (val!.isNotEmpty) {
                    profile!.upiCode = val;
                  }
                  return null;
                },
              ),

              // TextInputField(
              //   labelTextStr: 'API URL / Link',
              //   prefixIcon: Icons.api_rounded,
              //   readOnly: true,
              //   initialValue: 'Premium Access Only',
              // ),
              // TextInputField(
              //   labelTextStr: 'API Auth Key',
              //   prefixIcon: Icons.security_rounded,
              //   readOnly: true,
              //   initialValue: 'Premium Access Only',
              // ),

              Row(
                children: [
                  AppButton(
                    label: 'Save Now',
                    onPressed: onSubmit,
                    stretch: true,
                  ),
                ],
              ),
              const Divider(),
              // backupUi(),
              // Expanded(
              //     child: Container(
              //   padding: const EdgeInsets.all(10),
              //   color: Colors.teal,
              //   child: const Center(
              //     child: Text('No Data Found'),
              //   ),
              // )),

              ...copyright().toList(),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row backupUi() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              Directory? appDocDir = await getApplicationDocumentsDirectory();
              String appPath = '${appDocDir.path}/data';
              backup(appPath, 'backup/data.zip');
            },
            icon: const Icon(Icons.save_as_outlined),
            label: const Text('Backup DB'),
          ),
        ),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.restore_rounded),
            label: const Text('Restore DB'),
          ),
        ),
      ],
    );
  }

  void onSubmit() {
    if (_form.currentState!.validate()) {
      Profile iPro = profile!;
      iPro.uid = uuid();
      iPro.save();

      final data = iPro.toString();
      log(data);
      showMessage(context, 'Profile Data saved successfully.');
    }
  }

  List<Widget> copyright() => [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Developed By: '),
            Text(
              'SDN Technology',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ];
}
