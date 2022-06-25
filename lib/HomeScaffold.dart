import 'package:castboard_showcaller/HomePopupMenu.dart';
import 'package:castboard_showcaller/containers/ShowfilePageContainer.dart';
import 'package:castboard_showcaller/global_keys.dart';
import 'package:castboard_showcaller/root_pages/remote_page/RemotePage.dart';
import 'package:castboard_showcaller/containers/CastChangePageContainer.dart';
import 'package:castboard_showcaller/enums.dart';
import 'package:castboard_showcaller/view_models/HomeScaffoldViewModel.dart';
import 'package:flutter/material.dart';

class HomeScaffold extends StatefulWidget {
  final HomeScaffoldViewModel viewModel;
  const HomeScaffold({Key? key, required this.viewModel}) : super(key: key);

  @override
  HomeScaffoldState createState() => HomeScaffoldState();
}

class HomeScaffoldState extends State<HomeScaffold>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomeScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Showcaller'),
        bottom: _getBottomAppBar(context, widget.viewModel, _tabController),
        actions: [
          HomePopupMenu(
            viewModel: widget.viewModel.popupMenuViewModel,
          )
        ],
      ),
      body: _getCurrentPage(widget.viewModel),
      
      floatingActionButton: widget.viewModel.currentPage == HomePage.castChanges
          ? FloatingActionButton(
              onPressed: widget.viewModel.onUploadCastChange,
              child: const Icon(Icons.cloud_upload),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _handleBottomNavBarTap,
        currentIndex: _getCurrentPageIndex(widget.viewModel),
        items: const [
          BottomNavigationBarItem(
            label: 'Remote',
            icon: Icon(Icons.settings_remote),
          ),
          BottomNavigationBarItem(
            label: 'Cast Changes',
            icon: Icon(Icons.sticky_note_2),
          ),
          BottomNavigationBarItem(
            label: 'Showfile',
            icon: Icon(Icons.folder),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget? _getBottomAppBar(BuildContext context,
      HomeScaffoldViewModel viewModel, TabController controller) {
    if (viewModel.currentPage == HomePage.castChanges) {
      return TabBar(
        controller: controller,
        onTap: _handleCastChangeTabTap,
        tabs: const [
          Tab(
            icon: Icon(Icons.sticky_note_2),
            child: Text('Cast Change'),
          ),
          Tab(
            icon: Icon(Icons.favorite),
            child: Text('Presets'),
          ),
        ],
      );
    }
    return null;
  }

  void _handleCastChangeTabTap(int index) {
    if (index == 0) {
      widget.viewModel.onCastChangeTabChanged(CastChangePageTab.presets);
    }

    if (index == 0) {
      widget.viewModel.onCastChangeTabChanged(CastChangePageTab.castChangeEdit);
    }
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
        return CastChangePageContainer(
          tabController: _tabController,
        );
      case HomePage.showfile:
      default:
        return const ShowfilePageContainer();
    }
  }

  void _handleBottomNavBarTap(int index) {
    switch (index) {
      case 0:
        widget.viewModel.onHomePageChanged(HomePage.remote);
        return;
      case 1:
        widget.viewModel.onHomePageChanged(HomePage.castChanges);
        return;
      case 2:
        widget.viewModel.onHomePageChanged(HomePage.showfile);
        return;
    }
  }
}
