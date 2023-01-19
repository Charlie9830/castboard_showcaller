import 'package:castboard_core/models/SlideMetadataModel.dart';
import 'package:castboard_core/models/SlideModel.dart';

class SlideSettingsPageViewModel {
  final Set<String> disabledSlideIds;
  final List<SlideModel> slides;
  final void Function(Set<String> value) onDisabledSlideIdsChanged;

  SlideSettingsPageViewModel({
    required this.disabledSlideIds,
    required this.slides,
    required this.onDisabledSlideIdsChanged,
  });
}
