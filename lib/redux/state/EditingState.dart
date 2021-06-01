import 'package:castboard_core/models/CastChangeModel.dart';
import 'package:castboard_core/models/PresetModel.dart';

class EditingState {
  final String selectedPresetId;
  final List<String> combinedPresetIds;
  final Set<String> freshPresetIds;
  final Set<String> deletedPresetIds;
  final Set<String> editedPresetIds;

  /// Represents 'Live' changes to cast changes, ie: changes that differ from what the presets have stored.
  /// Similiar to how a [StatefulWidget] can accept an inital value passed in as a property, then modifies another instance
  /// of that value within it's own State to represent changes.
  final CastChangeModel editedAssignments;

  EditingState({
    required this.selectedPresetId,
    required this.combinedPresetIds,
    required this.editedAssignments,
    required this.freshPresetIds,
    required this.deletedPresetIds,
    required this.editedPresetIds,
  });

  EditingState.initial()
      : selectedPresetId = const PresetModel.builtIn().uid,
        combinedPresetIds = const [],
        editedAssignments = CastChangeModel.initial(),
        freshPresetIds = const {},
        deletedPresetIds = const {},
        editedPresetIds = const {};

  EditingState copyWith({
    String? selectedPresetId,
    List<String>? combinedPresetIds,
    Set<String>? freshPresetIds,
    Set<String>? deletedPresetIds,
    Set<String>? editedPresetIds,
    CastChangeModel? editedAssignments,
  }) {
    return EditingState(
      selectedPresetId: selectedPresetId ?? this.selectedPresetId,
      combinedPresetIds: combinedPresetIds ?? this.combinedPresetIds,
      freshPresetIds: freshPresetIds ?? this.freshPresetIds,
      deletedPresetIds: deletedPresetIds ?? this.deletedPresetIds,
      editedPresetIds: editedPresetIds ?? this.editedPresetIds,
      editedAssignments: editedAssignments ?? this.editedAssignments,
    );
  }
}
