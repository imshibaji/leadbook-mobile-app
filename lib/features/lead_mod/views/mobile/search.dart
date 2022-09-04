import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../lead_mod.dart';

class SearchForMobile extends StatelessWidget {
  const SearchForMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: searchBarTitle(),
        ),
        actions: actionsMenu(context),
      ),
      bottomNavigationBar: LeadAppBottomBar(),
    );
  }
}
