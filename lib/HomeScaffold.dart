import 'package:castboard_remote/RemotePage.dart';
import 'package:castboard_remote/enums.dart';
import 'package:castboard_remote/view_models/HomeScaffoldViewModel.dart';
import 'package:flutter/material.dart';

class HomeScaffold extends StatelessWidget {
  final HomeScaffoldViewModel viewModel;
  const HomeScaffold({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Castboard Remote'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (buttonContext) => [
              PopupMenuItem(child: Text('Player Settings')),
            ],
          ),
        ],
      ),
      body: _getCurrentPage(viewModel),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _handleBottomNavBarTap,
        currentIndex: _getCurrentPageIndex(viewModel),
        items: [
          BottomNavigationBarItem(
            label: 'Remote',
            icon: Icon(Icons.settings_remote),
          ),
          BottomNavigationBarItem(
            label: 'Cast Change',
            icon: Icon(Icons.sticky_note_2),
          ),
          BottomNavigationBarItem(
            label: 'Show File',
            icon: Icon(Icons.folder),
          )
        ],
      ),
    );
  }

  int _getCurrentPageIndex(HomeScaffoldViewModel viewModel) {
    switch (viewModel.currentPage) {
      case HomePage.remote:
        return 0;
      case HomePage.castChanges:
        return 1;
      case HomePage.showfile:
        return 2;
    }
  }

  Widget _getCurrentPage(HomeScaffoldViewModel viewModel) {
    switch (viewModel.currentPage) {
      case HomePage.remote:
        return RemotePage(
          onPlayPressed: () => viewModel.onPlaybackAction(PlaybackAction.play),
          onPausePressed: () =>
              viewModel.onPlaybackAction(PlaybackAction.pause),
          onNextPressed: () => viewModel.onPlaybackAction(PlaybackAction.next),
          onPrevPressed: () => viewModel.onPlaybackAction(PlaybackAction.prev),
        );
      case HomePage.castChanges:
        return SizedBox();
      case HomePage.showfile:
        return SizedBox();
      default:
        return SizedBox();
    }
  }

  void _handleBottomNavBarTap(int index) {
    switch (index) {
      case 0:
        viewModel.onHomePageChanged(HomePage.remote);
        return;
      case 1:
        viewModel.onHomePageChanged(HomePage.castChanges);
        return;
      case 2:
        viewModel.onHomePageChanged(HomePage.showfile);
        return;
    }
  }
}
