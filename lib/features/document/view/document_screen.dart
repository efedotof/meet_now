import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/document/cubit/document_cubit.dart';
import 'package:meet_now_app/features/document/widget/widget.dart';

@RoutePage()
class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key, required this.type});
  final String type;

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DocumentCubit>().getDocument(type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final content = BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, state) {
        return state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded:
              (document) => SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ParseMarkup(text: document),
              ),
          error: (error) => Center(child: Text(error)),
        );
      },
    );

    final appBar = const AppBarWidget();

    return Scaffold(
      body:
          isMobile
              ? Stack(
                children: [
                  SizedBox(
                    width: screenWidth,
                    height: MediaQuery.of(context).size.height,
                    child: content,
                  ),
                  Positioned(top: 20, left: 4, right: 4, child: appBar),
                ],
              )
              : Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: appBar,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: content,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
