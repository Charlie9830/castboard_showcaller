import 'package:castboard_remote/cast_change_page/CastChangeEditTab.dart';
import 'package:castboard_remote/cast_change_page/PresetListTab.dart';
import 'package:castboard_remote/view_models/CastChangePageViewModel.dart';
import 'package:flutter/material.dart';

class CastChangePage extends StatelessWidget {
  final TabController tabController;
  final CastChangePageViewModel viewModel;
  const CastChangePage(
      {Key? key, required this.tabController, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TabBarView(
      controller: tabController,
      children: [
        PresetListTab(viewModel: viewModel),
        CastChangeEditTab(viewModel: viewModel,),
      ],
    ));
  }
}
