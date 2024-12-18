import 'package:bloc/bloc.dart';
import 'package:de_comp_core/de_comp_core.dart';
import 'package:flutter/widgets.dart';

/// Extended version of [DisposableHolder] to support Flutter-specific disposables.
extension DisposableHolderFlutter on DisposableHolder {
  void addBloc<T, E>(Bloc<T, E> bloc) => addCustomDisposable(
        bloc,
        bloc.close,
      );

  void addErrorSink(ErrorSink sink) => addCustomDisposable(
        sink,
        sink.close,
      );

  void addClosable(Closable closable) => addCustomDisposable(
        closable,
        closable.close,
      );

  void addTextEditingController(TextEditingController controller) => addCustomDisposable(
        controller,
        controller.dispose,
      );

  void addAnimationController(AnimationController animationController) => addCustomDisposable(
        animationController,
        animationController.dispose,
      );
}

extension BlocExtension<E, S> on Bloc<E, S> {
  Bloc<E, S> addToDisposableHolder(DisposableHolder disposableHolder) {
    disposableHolder.addBloc<E, S>(this);
    return this;
  }
}

extension ErrorSinkExtension on ErrorSink {
  ErrorSink addToDisposableHolder(DisposableHolder disposableHolder) {
    disposableHolder.addErrorSink(this);
    return this;
  }
}

extension TextEditingControllerExtension on TextEditingController {
  TextEditingController addToDisposableHolder(DisposableHolder disposableHolder) {
    disposableHolder.addTextEditingController(this);
    return this;
  }
}

extension AnimationControllerExtension on AnimationController {
  AnimationController addToDisposableHolder(DisposableHolder disposableHolder) {
    disposableHolder.addAnimationController(this);
    return this;
  }
}
