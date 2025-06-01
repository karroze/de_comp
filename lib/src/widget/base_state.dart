import 'package:de_comp/de_comp.dart';
import 'package:flutter/widgets.dart';

/// Base state to implement disposing and ease bloc acquisition.
abstract class BaseState<T extends StatefulWidget> extends State<T> with DisposableHolderMixin {
  /// Reads [BLOC] from context
  BLOC bloc<BLOC extends BaseBloc<Object, Object, Object, Object>>() => context.read<BLOC>();

  @override
  void dispose() {
    disposableHolder.dispose();
    super.dispose();
  }
}
