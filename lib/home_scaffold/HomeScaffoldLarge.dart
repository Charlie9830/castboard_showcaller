import 'package:castboard_showcaller/containers/ShowfilePageContainer.dart';
import 'package:castboard_showcaller/global_keys.dart';
import 'package:castboard_showcaller/containers/CastChangePageContainer.dart';
import 'package:castboard_showcaller/enums.dart';
import 'package:castboard_showcaller/root_pages/remote_page/RemotePage.dart';
import 'package:castboard_showcaller/view_models/HomeScaffoldViewModel.dart';
import 'package:flutter/material.dart';

class HomeScaffoldLarge extends StatefulWidget {
  final HomeScaffoldViewModel viewModel;
  const HomeScaffoldLarge({Key? key, required this.viewModel})
      : super(key: key);

  @override
  HomeScaffoldLargeState createState() => HomeScaffoldLargeState();
}

class HomeScaffoldLargeState extends State<HomeScaffoldLarge>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBar(context),
      bottomNavigationBar: _buildBottomBar(context),
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.selected,
            selectedIndex: _getNavRailIndex(),
            onDestinationSelected: _handleNavRailDestinationSelected,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.sticky_note_2), label: Text('Cast Changes')),
              NavigationRailDestination(
                  icon: Icon(Icons.folder), label: Text('Showfile')),
              NavigationRailDestination(
                  icon: Icon(Icons.settings), label: Text('Settings'))
            ],
          ),
          Expanded(child: _getCurrentPage(widget.viewModel)),
        ],
      ),
    );
  }

  int _getNavRailIndex() {
    switch (widget.viewModel.currentPage) {
      case HomePage.remote:
        return 0;
      case HomePage.castChanges:
        return 0;
      case HomePage.showfile:
        return 1;
    }
  }

  void _handleNavRailDestinationSelected(int index) {
    switch (index) {
      case 0:
        widget.viewModel.onHomePageChanged(HomePage.castChanges);
        break;
      case 1:
        widget.viewModel.onHomePageChanged(HomePage.showfile);
        break;
      case 2:
        widget.viewModel.onSettingsButtonPressed();
        break;
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Showcaller'),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      elevation: 24,
      child: SizedBox(
        height: 56,
        child: Stack(
          children: [
            Positioned(
              right: 16,
              bottom: 14,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 125),
                scale: widget.viewModel.currentPage == HomePage.castChanges
                    ? 1
                    : 0,
                child: ElevatedButton.icon(
                  onPressed: () => widget.viewModel.onUploadCastChange(),
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Upload'),
                ),
              ),
            ),
            RemotePage(
              useDesktopLayout: true,
              onNextPressed: () =>
                  widget.viewModel.onPlaybackAction(PlaybackAction.next),
              onPlayPressed: () =>
                  widget.viewModel.onPlaybackAction(PlaybackAction.play),
              onPausePressed: () =>
                  widget.viewModel.onPlaybackAction(PlaybackAction.pause),
              onPrevPressed: () =>
                  widget.viewModel.onPlaybackAction(PlaybackAction.prev),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCurrentPage(HomeScaffoldViewModel viewModel) {
    switch (viewModel.currentPage) {
      case HomePage.castChanges:
        return const CastChangePageContainer();
      case HomePage.showfile:
        return const ShowfilePageContainer();
      default:
        return const ShowfilePageContainer();
    }
  }
}
