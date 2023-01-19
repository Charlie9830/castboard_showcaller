import 'package:castboard_core/models/SlideModel.dart';
import 'package:castboard_showcaller/redux/actions/AsyncActions.dart';
import 'package:castboard_showcaller/redux/actions/SyncActions.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';
import 'package:castboard_showcaller/root_pages/showfile_page/ShowfilePage.dart';
import 'package:castboard_showcaller/root_pages/slides_settings/slide_settings_page_large.dart';
import 'package:castboard_showcaller/view_models/ShowfilePageViewModel.dart';
import 'package:castboard_showcaller/view_models/slide_settings_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SlideSettingsContainer extends StatelessWidget {
  const SlideSettingsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SlideSettingsPageViewModel>(
      builder: (context, viewModel) {
        return SlideSettingsPageLarge(
          viewModel: viewModel,
        );
      },
      converter: (Store<AppState> store) {
        return SlideSettingsPageViewModel(
            disabledSlideIds: store.state.editingState.disabledSlideIds,
            slides: store.state.editingState.slidesMetadata
                .map((metadata) => SlideModel(
                      uid: metadata.slideId,
                      name: metadata.slideName,
                      index: metadata.index,
                    ))
                .toList(),
            onDisabledSlideIdsChanged: (value) =>
                store.dispatch(SetDisabledSlideIds(value)));
      },
    );
  }
}
