import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:de_comp_core/de_comp_core.dart';

abstract class BaseBloc<Event, State, Action, Localization>
    extends Bloc<Event, State> with DisposableHolderMixin {
  BaseBloc({
    required State baseState,
    required this.localization,
  }) : super(baseState);

  late final _actionsSubject = StreamController<Action>.broadcast()
      .addToDisposableHolder(disposableHolder);

  final Localization localization;

  Stream<Action> get actions => _actionsSubject.stream;

  void emitAction(Action action) {
    if (_actionsSubject.isClosed) return;
    _actionsSubject.sink.add(action);
  }

  @override
  Future<void> close() {
    disposableHolder.dispose();
    return super.close();
  }
}
