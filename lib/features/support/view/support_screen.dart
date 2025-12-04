import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/support/cubit/support_cubit.dart';
import 'package:meet_now_app/features/support/widget/widget.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SupportCubit>().getMyQuestions();
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [Color(0xFFD8E3E7), Color(0xFFC8D5DA), Color(0xFFD8E3E7)],
        stops: [0.1, 0.5, 0.9],
      ),
      darkShimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
        ],
        stops: [0.0, 0.2, 0.5, 0.8, 1],
        begin: Alignment(-2.4, -0.2),
        end: Alignment(2.4, 0.2),
        tileMode: TileMode.clamp,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.grey[50],
              child: BlocConsumer<SupportCubit, SupportState>(
                listener: (context, state) {
                  state.whenOrNull(
                    questionCreated: (question) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Вопрос успешно создан'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      context.read<SupportCubit>().getMyQuestions();
                    },
                    statusUpdated: (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Статус обновлен'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    error: (message) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ошибка: $message'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                },
                builder: (context, state) {
                  return state.when(
                    initial: () => const QuestionsSkeleton(),
                    loading: () => const QuestionsSkeleton(),
                    myQuestionsLoaded: (questions) {
                      if (questions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.help_outline,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Вопросов пока нет',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Нажмите "+" чтобы создать вопрос',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[500]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          QuestionsList(questions),
                        ],
                      );
                    },
                    questionDetail: (question) => QuestionDetail(question),
                    questionCreated: (question) => QuestionDetail(question),
                    statusUpdated: (question) => QuestionDetail(question),
                    error:
                        (message) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Произошла ошибка',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Text(
                                  message,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed:
                                    () =>
                                        context
                                            .read<SupportCubit>()
                                            .getMyQuestions(),
                                child: const Text('Попробовать снова'),
                              ),
                            ],
                          ),
                        ),
                  );
                },
              ),
            ),
            const AppBarWidget(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:
              () => showDialog(
                context: context,
                builder: (context) => const CreateQuestionDialog(),
              ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
