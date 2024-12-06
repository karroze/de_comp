import 'package:bloc/bloc.dart';
import 'package:de_comp_core/de_comp_core.dart';

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
