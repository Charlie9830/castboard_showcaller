import 'package:castboard_core/models/CastChangeModel.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/SlideMetadataModel.dart';

class EditingState {
  final bool hasUploadableEdits;
  final String selectedPresetId;
  final List<String> combinedPresetIds;
  final Set<String> freshPresetIds;
  final Set<String> deletedPresetIds;
  final Set<String> editedPresetIds;
  final List<SlideMetadataModel> slidesMetadata;
  final Set<String> disabledSlideIds;

  /// Represents 'Live' changes to cast changes, ie: changes that differ from what the presets have stored.
  /// Similiar to how a [StatefulWidget] can accept an inital value passed in as a property, then modifies another instance
  /// of that value within it's own State to represent changes.
  final CastChangeModel editedAssignments;

  EditingState({
    required this.hasUploadableEdits,
    required this.selectedPresetId,
    required this.combinedPresetIds,
    required this.editedAssignments,
    required this.freshPresetIds,
    required this.deletedPresetIds,
    required this.editedPresetIds,
    required this.disabledSlideIds,
    required this.slidesMetadata,
  });

  EditingState.initial()
      : selectedPresetId = const PresetModel.builtIn().uid,
        combinedPresetIds = const [],
        editedAssignments = const CastChangeModel.initial(),
        freshPresetIds = const {},
        deletedPresetIds = const {},
        editedPresetIds = const {},
        slidesMetadata = const [],
        disabledSlideIds = const {},
        hasUploadableEdits = false;

  EditingState copyWith({
    String? selectedPresetId,
    List<String>? combinedPresetIds,
    Set<String>? freshPresetIds,
    Set<String>? deletedPresetIds,
    Set<String>? editedPresetIds,
    List<SlideMetadataModel>? slidesMetadata,
    Set<String>? disabledSlideIds,
    CastChangeModel? editedAssignments,
    bool? hasUploadableEdits,
  }) {
    return EditingState(
      selectedPresetId: selectedPresetId ?? this.selectedPresetId,
      combinedPresetIds: combinedPresetIds ?? this.combinedPresetIds,
      freshPresetIds: freshPresetIds ?? this.freshPresetIds,
      deletedPresetIds: deletedPresetIds ?? this.deletedPresetIds,
      editedPresetIds: editedPresetIds ?? this.editedPresetIds,
      slidesMetadata: slidesMetadata ?? this.slidesMetadata,
      disabledSlideIds: disabledSlideIds ?? this.disabledSlideIds,
      editedAssignments: editedAssignments ?? this.editedAssignments,
      hasUploadableEdits: hasUploadableEdits ?? this.hasUploadableEdits,
    );
  }
}
