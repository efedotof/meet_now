import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/social/news_response/news_response.dart';
import 'package:meet_now_app_server/repository/news/news_interface.dart';

part 'news_cubit.freezed.dart';
part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsInterface newsInterface;

  NewsCubit({required this.newsInterface}) : super(const NewsState.initial());

  Future<void> getActiveNews() async {
    emit(const NewsState.loading());
    try {
      final news = await newsInterface.getActiveNews();
      emit(NewsState.news(news: news));
    } on Exception catch (e) {
      emit(NewsState.error(error: e.toString()));
    }
  }
}
