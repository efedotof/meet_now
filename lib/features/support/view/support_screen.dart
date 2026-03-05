import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/support/cubit/support_cubit.dart';
import 'package:meet_now_app/features/support/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SupportCubit>().getMyQuestions();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

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
            Positioned.fill(
              top: isMobile ? MediaQuery.of(context).padding.top + 80 : 80,
              bottom: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 600,
                    maxHeight: isMobile ? double.infinity : 700,
                  ),
                  child: Container(
                    margin: EdgeInsets.all(isMobile ? 0 : 16),
                    decoration:
                        isMobile
                            ? null
                            : BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                    child: BlocConsumer<SupportCubit, SupportState>(
                      listener: (context, state) {
                        state.whenOrNull(
                          questionCreated: (question) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  S
                                      .of(context)
                                      .the_question_was_created_successfully,
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                            context.read<SupportCubit>().getMyQuestions();
                          },
                          statusUpdated: (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).status_updated),
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
                          initial: () => QuestionsSkeleton(isMobile: isMobile),
                          loading: () => QuestionsSkeleton(isMobile: isMobile),
                          myQuestionsLoaded: (questions) {
                            if (questions.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.help_outline,
                                      size: isMobile ? 80 : 100,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      S.of(context).no_questions_yet,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: isMobile ? null : 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 32 : 48,
                                      ),
                                      child: Text(
                                        S
                                            .of(context)
                                            .click_plus_to_create_a_question,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[500],
                                          fontSize: isMobile ? null : 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ExpandedQuestionsList(
                              questions,
                              isMobile: isMobile,
                            );
                          },
                          questionDetail:
                              (question) =>
                                  QuestionsList([question], isMobile: isMobile),
                          questionCreated:
                              (question) =>
                                  QuestionsList([question], isMobile: isMobile),
                          statusUpdated:
                              (question) =>
                                  QuestionsList([question], isMobile: isMobile),
                          error:
                              (message) => Center(
                                child: Padding(
                                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: isMobile ? 64 : 80,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        S.of(context).an_error_has_occurred,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          fontSize: isMobile ? null : 18,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isMobile ? 32 : 48,
                                        ),
                                        child: Text(
                                          message,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontSize: isMobile ? null : 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed:
                                            () =>
                                                context
                                                    .read<SupportCubit>()
                                                    .getMyQuestions(),
                                        child: Text(
                                          S.of(context).try_again,
                                          style: TextStyle(
                                            fontSize: isMobile ? null : 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const AppBarWidget(),
          ],
        ),
        floatingActionButton:
            isMobile
                ? FloatingActionButton(
                  onPressed:
                      () => showDialog(
                        context: context,
                        builder:
                            (context) =>
                                CreateQuestionDialog(isMobile: isMobile),
                      ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.add),
                )
                : Container(
                  margin: const EdgeInsets.all(16),
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder:
                              (context) =>
                                  CreateQuestionDialog(isMobile: isMobile),
                        ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.add),
                    label: Text(S.of(context).create_a_question),
                  ),
                ),
      ),
    );
  }
}
