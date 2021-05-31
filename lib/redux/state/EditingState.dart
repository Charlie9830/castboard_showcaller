import 'package:castboard_core/models/CastChangeModel.dart';

class EditingState {
  final String selectedPresetId;
  final List<String> combinedPresetIds;

  /// Represents 'Live' changes to cast changes, ie: changes that differ from what the presets have stored.
  /// Similiar to how a [StatefulWidget] can accept an inital value passed in as a property, then modifies another instance
  /// of that value within it's own State to represent changes.
  final CastChangeModel editedAssignments;

  EditingState({
    required this.selectedPresetId,
    required this.combinedPresetIds,
    required this.editedAssignments,
  });

  EditingState.initial()
      : selectedPresetId = '',
        combinedPresetIds = const [],
        editedAssignments = CastChangeModel.initial();

  EditingState copyWith({
    String? selectedPresetId,
    List<String>? combinedPresetIds,
    CastChangeModel? editedAssignments,
  }) {
    return EditingState(
      selectedPresetId: selectedPresetId ?? this.selectedPresetId,
      combinedPresetIds: combinedPresetIds ?? this.combinedPresetIds,
      editedAssignments: editedAssignments ?? this.editedAssignments,
    );
  }
}
