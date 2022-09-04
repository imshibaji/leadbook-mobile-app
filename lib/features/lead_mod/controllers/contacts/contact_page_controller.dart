import 'package:flutter/material.dart';

import '../../../../core/classes/controller_manager.dart';
import '../../../../core/classes/display_manager.dart';
import '../../views/mobile/contacts/contact_page.dart';

class ContactPageController extends StatelessController {
  const ContactPageController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(title: 'Contact Page', mobile: const ContactPage());
  }
}
