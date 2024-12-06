import 'package:de_comp_core/de_comp_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> with DisposableHolderMixin {
  BLOC bloc<BLOC>() => context.read<BLOC>();

  @override
  void dispose() {
    disposableHolder.dispose();
    super.dispose();
  }
}
