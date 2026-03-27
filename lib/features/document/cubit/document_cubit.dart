import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/repository/document/document_interface.dart';

part 'document_state.dart';
part 'document_cubit.freezed.dart';

class DocumentCubit extends Cubit<DocumentState> {
  DocumentCubit({required DocumentInterface documentInterface})
    : _documentInterface = documentInterface,
      super(DocumentState.loading());

  final DocumentInterface _documentInterface;

  Future<void> getDocument({required String type}) async {
    emit(DocumentState.loading());

    try {
      final response = await _documentInterface.getDocument(type: type);
      if (response.isEmpty) {
        emit(DocumentState.loaded(document: "Документ не найден"));
      } else {
        emit(DocumentState.loaded(document: response));
      }
    } catch (e) {
      emit(DocumentState.error(error: e.toString()));
    }
  }
}
