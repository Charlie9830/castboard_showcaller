import 'package:castboard_core/models/CastChangeModel.dart';

class EditingState {
  final String selectedPresetId;
  final List<String> combinedPresetIds;
  final CastChangeModel activeCastChange;

  EditingState({
    required this.selectedPresetId,
    required this.combinedPresetIds,
    required this.activeCastChange,
  });

  EditingState.initial()
      : selectedPresetId = '',
        combinedPresetIds = const [],
        activeCastChange = CastChangeModel.initial();

  EditingState copyWith({
    String? selectedPresetId,
    List<String>? combinedPresetIds,
    CastChangeModel? activeCastChange,
  }) {
    return EditingState(
      selectedPresetId: selectedPresetId ?? this.selectedPresetId,
      combinedPresetIds: combinedPresetIds ?? this.combinedPresetIds,
      activeCastChange: activeCastChange ?? this.activeCastChange,
    );
  }
}
