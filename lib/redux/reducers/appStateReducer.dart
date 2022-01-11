import 'package:castboard_core/classes/PhotoRef.dart';
import 'package:castboard_core/models/ActorModel.dart';
import 'package:castboard_core/models/ActorRef.dart';
import 'package:castboard_core/models/CastChangeModel.dart';
import 'package:castboard_core/models/PresetModel.dart';
import 'package:castboard_core/models/TrackModel.dart';
import 'package:castboard_core/models/TrackRef.dart';
import 'package:castboard_showcaller/enums.dart';
import 'package:castboard_showcaller/redux/actions/SyncActions.dart';
import 'package:castboard_showcaller/redux/reducers/editingStateReducer.dart';
import 'package:castboard_showcaller/redux/reducers/navStateReducer.dart';
import 'package:castboard_showcaller/redux/reducers/playerStateReducer.dart';
import 'package:castboard_showcaller/redux/reducers/showStateReducer.dart';
import 'package:castboard_showcaller/redux/state/AppState.dart';

AppState appStateReducer(AppState state, dynamic action) {
  if (action is InitMockData) {
    return state.copyWith(
      navState: state.navState.copyWith(
        homePage: HomePage.castChanges,
        castChangePageTab: CastChangePageTab.presets,
      ),
      showState: state.showState.copyWith(
        actors: {
          ActorRef('ID-bront'):
              ActorModel(ref: ActorRef('ID-bront'), name: 'Bront'),
          ActorRef('ID-fancy'):
              ActorModel(ref: ActorRef('ID-fancy'), name: 'Fancy'),
          ActorRef('ID-goofy'):
              ActorModel(ref: ActorRef('ID-goofy'), name: 'Goofy'),
          ActorRef('ID-snowy'):
              ActorModel(ref: ActorRef('ID-snowy'), name: 'Snowy'),
          ActorRef('ID-pittie'):
              ActorModel(ref: ActorRef('ID-pittie'), name: 'Pittie'),
          ActorRef('ID-pugglesworth'): ActorModel(
              ref: ActorRef('ID-pugglesworth'), name: 'Pugglesworth'),
          ActorRef('ID-shiba'):
              ActorModel(ref: ActorRef('ID-shiba'), name: 'Shiba'),
          ActorRef('ID-klaus'):
              ActorModel(ref: ActorRef('ID-klaus'), name: 'Klaus'),
          ActorRef('ID-jimmy'):
              ActorModel(ref: ActorRef('ID-jimmy'), name: 'Jimmy'),
        },
        tracks: {
          TrackRef('ID-TRACK-bully'): TrackModel(
              ref: TrackRef('ID-TRACK-bully'),
              title: 'The Bully',
              internalTitle: 'The Bully'),
          TrackRef('ID-TRACK-mayor'): TrackModel(
              ref: TrackRef('ID-TRACK-mayor'),
              title: 'The Mayor',
              internalTitle: 'The Mayor'),
          TrackRef('ID-TRACK-surfer'): TrackModel(
              ref: TrackRef('ID-TRACK-surfer'),
              title: 'The Surfer',
              internalTitle: 'The Surfer'),
          TrackRef('ID-TRACK-tracker'): TrackModel(
              ref: TrackRef('ID-TRACK-tracker'),
              title: 'The Tracker',
              internalTitle: 'The Tracker'),
          TrackRef('ID-TRACK-heroin'): TrackModel(
              ref: TrackRef('ID-TRACK-heroin'),
              title: 'The Heroin',
              internalTitle: 'The Heroin'),
          TrackRef('ID-TRACK-igor'): TrackModel(
              ref: TrackRef('ID-TRACK-igor'),
              title: 'Igor',
              internalTitle: 'Igor'),
          TrackRef('ID-TRACK-screamer'): TrackModel(
              ref: TrackRef('ID-TRACK-screamer'),
              title: 'The Screamer',
              internalTitle: 'The Screamer'),
          TrackRef('ID-TRACK-captain'): TrackModel(
              ref: TrackRef('ID-TRACK-captain'),
              title: 'Captain Merkel',
              internalTitle: 'Captain Merkel'),
          TrackRef('ID-TRACK-politician'): TrackModel(
              ref: TrackRef('ID-TRACK-politician'),
              title: 'The Politician',
              internalTitle: 'The Politician'),
        },
        presets: {
          PresetModel.builtIn().uid: PresetModel.builtIn().copyWith(
            castChange: CastChangeModel({
              TrackRef('ID-TRACK-bully'): ActorRef('ID-bront'),
              TrackRef('ID-TRACK-mayor'): ActorRef('ID-fancy'),
              TrackRef('ID-TRACK-surfer'): ActorRef('ID-goofy'),
              TrackRef('ID-TRACK-tracker'): ActorRef('ID-snowy'),
              TrackRef('ID-TRACK-heroin'): ActorRef('ID-pittie'),
              TrackRef('ID-TRACK-igor'): ActorRef('ID-pugglesworth'),
              TrackRef('ID-TRACK-screamer'): ActorRef.unassigned(),
              TrackRef('ID-TRACK-captain'): ActorRef.unassigned(),
              TrackRef('ID-TRACK-politician'): ActorRef.unassigned(),
            }),
          ),
          'nestedPreset1': PresetModel(
            uid: 'nestedPreset1',
            isNestable: true,
            name: 'Diamonds',
            castChange: CastChangeModel(
              {
                TrackRef('ID-TRACK-screamer'): ActorRef('ID-shiba'),
                TrackRef('ID-TRACK-captain'): ActorRef('ID-klaus'),
                TrackRef('ID-TRACK-politician'): ActorRef('ID-jimmy'),
              },
            ),
          )
        },
      ),
    );
  }

  return state.copyWith(
    showState: showStateReducer(state.showState, action),
    navState: navStateReducer(state.navState, action),
    playerState: playerStateReducer(state.playerState, action),
    editingState: editingStateReducer(state.editingState, action),
  );
}
