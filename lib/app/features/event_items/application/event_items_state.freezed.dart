// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_items_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EventItemsState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<EventItem> get eventItems => throw _privateConstructorUsedError;
  List<SongModelV2> get songsFromEvent => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;

  /// Create a copy of EventItemsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventItemsStateCopyWith<EventItemsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventItemsStateCopyWith<$Res> {
  factory $EventItemsStateCopyWith(
          EventItemsState value, $Res Function(EventItemsState) then) =
      _$EventItemsStateCopyWithImpl<$Res, EventItemsState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<EventItem> eventItems,
      List<SongModelV2> songsFromEvent,
      int currentIndex});
}

/// @nodoc
class _$EventItemsStateCopyWithImpl<$Res, $Val extends EventItemsState>
    implements $EventItemsStateCopyWith<$Res> {
  _$EventItemsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventItemsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? eventItems = null,
    Object? songsFromEvent = null,
    Object? currentIndex = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      eventItems: null == eventItems
          ? _value.eventItems
          : eventItems // ignore: cast_nullable_to_non_nullable
              as List<EventItem>,
      songsFromEvent: null == songsFromEvent
          ? _value.songsFromEvent
          : songsFromEvent // ignore: cast_nullable_to_non_nullable
              as List<SongModelV2>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventItemsStateImplCopyWith<$Res>
    implements $EventItemsStateCopyWith<$Res> {
  factory _$$EventItemsStateImplCopyWith(_$EventItemsStateImpl value,
          $Res Function(_$EventItemsStateImpl) then) =
      __$$EventItemsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<EventItem> eventItems,
      List<SongModelV2> songsFromEvent,
      int currentIndex});
}

/// @nodoc
class __$$EventItemsStateImplCopyWithImpl<$Res>
    extends _$EventItemsStateCopyWithImpl<$Res, _$EventItemsStateImpl>
    implements _$$EventItemsStateImplCopyWith<$Res> {
  __$$EventItemsStateImplCopyWithImpl(
      _$EventItemsStateImpl _value, $Res Function(_$EventItemsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventItemsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? eventItems = null,
    Object? songsFromEvent = null,
    Object? currentIndex = null,
  }) {
    return _then(_$EventItemsStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      eventItems: null == eventItems
          ? _value._eventItems
          : eventItems // ignore: cast_nullable_to_non_nullable
              as List<EventItem>,
      songsFromEvent: null == songsFromEvent
          ? _value._songsFromEvent
          : songsFromEvent // ignore: cast_nullable_to_non_nullable
              as List<SongModelV2>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$EventItemsStateImpl implements _EventItemsState {
  const _$EventItemsStateImpl(
      {this.isLoading = false,
      final List<EventItem> eventItems = const [],
      final List<SongModelV2> songsFromEvent = const [],
      this.currentIndex = 0})
      : _eventItems = eventItems,
        _songsFromEvent = songsFromEvent;

  @override
  @JsonKey()
  final bool isLoading;
  final List<EventItem> _eventItems;
  @override
  @JsonKey()
  List<EventItem> get eventItems {
    if (_eventItems is EqualUnmodifiableListView) return _eventItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eventItems);
  }

  final List<SongModelV2> _songsFromEvent;
  @override
  @JsonKey()
  List<SongModelV2> get songsFromEvent {
    if (_songsFromEvent is EqualUnmodifiableListView) return _songsFromEvent;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_songsFromEvent);
  }

  @override
  @JsonKey()
  final int currentIndex;

  @override
  String toString() {
    return 'EventItemsState(isLoading: $isLoading, eventItems: $eventItems, songsFromEvent: $songsFromEvent, currentIndex: $currentIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventItemsStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._eventItems, _eventItems) &&
            const DeepCollectionEquality()
                .equals(other._songsFromEvent, _songsFromEvent) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_eventItems),
      const DeepCollectionEquality().hash(_songsFromEvent),
      currentIndex);

  /// Create a copy of EventItemsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventItemsStateImplCopyWith<_$EventItemsStateImpl> get copyWith =>
      __$$EventItemsStateImplCopyWithImpl<_$EventItemsStateImpl>(
          this, _$identity);
}

abstract class _EventItemsState implements EventItemsState {
  const factory _EventItemsState(
      {final bool isLoading,
      final List<EventItem> eventItems,
      final List<SongModelV2> songsFromEvent,
      final int currentIndex}) = _$EventItemsStateImpl;

  @override
  bool get isLoading;
  @override
  List<EventItem> get eventItems;
  @override
  List<SongModelV2> get songsFromEvent;
  @override
  int get currentIndex;

  /// Create a copy of EventItemsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventItemsStateImplCopyWith<_$EventItemsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
