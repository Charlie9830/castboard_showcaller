import 'package:castboard_showcaller/root_pages/cast_change/CastChangeEditTab.dart';
import 'package:castboard_showcaller/root_pages/cast_change/PresetListTab.dart';
import 'package:castboard_showcaller/view_models/CastChangePageViewModel.dart';
import 'package:flutter/material.dart';

class CastChangePage extends StatelessWidget {
  final TabController tabController;
  final CastChangePageViewModel viewModel;
  const CastChangePage(
      {Key? key, required this.tabController, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
