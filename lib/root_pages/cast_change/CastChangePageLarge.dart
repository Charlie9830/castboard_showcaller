import 'package:castboard_showcaller/CastChangeActionsMenu.dart';
import 'package:castboard_showcaller/root_pages/cast_change/CastChangeEditTab.dart';
import 'package:castboard_showcaller/root_pages/cast_change/PresetListTab.dart';
import 'package:castboard_showcaller/view_models/CastChangePageViewModel.dart';
import 'package:flutter/material.dart';

class CastChangePageLarge extends StatelessWidget {
  final CastChangePageViewModel viewModel;
  const CastChangePageLarge({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 420,
            child: Column(
              children: [
                const _Title('Presets'),
                Expanded(child: PresetListTab(viewModel: viewModel)),
              ],
            )),
        const VerticalDivider(),
        SizedBox(
          width: 600,
          child: Column(
            children: [
              _Title(
                'Cast Change',
                trailing: CastChangeActionsMenu(
                  updateEnabled: viewModel.allowPresetUpdates,
                  onResetChanges: viewModel.onResetChanges,
                  onUpdatePreset: viewModel.onUpdatePreset,
                ),
              ),
              Expanded(
                child: CastChangeEditTab(
                  viewModel: viewModel,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _Title(
    this.title, {
    this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: trailing ?? SizedBox.fromSize(size: Size.zero),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ],
      ),
    );
  }
}
