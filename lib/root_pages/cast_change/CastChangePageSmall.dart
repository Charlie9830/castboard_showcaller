import 'package:castboard_showcaller/root_pages/cast_change/CastChangeEditTab.dart';
import 'package:castboard_showcaller/root_pages/cast_change/PresetListTab.dart';
import 'package:castboard_showcaller/view_models/CastChangePageViewModel.dart';
import 'package:flutter/material.dart';

class CastChangePageSmall extends StatelessWidget {
  final TabController? tabController;
  final CastChangePageViewModel viewModel;
  const CastChangePageSmall(
      {Key? key, this.tabController, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tabController == null) {
      return const Text("Please provide instantiated TabController");
    }
    return TabBarView(
      controller: tabController,
      children: [
        CastChangeEditTab(
          viewModel: viewModel,
        ),
        PresetListTab(viewModel: viewModel),
      ],
    );
  }
}
