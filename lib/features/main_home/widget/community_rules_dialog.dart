import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/document/cubit/document_cubit.dart';
import 'package:meet_now_app/features/document/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/storage/agree_rules/agree_rules_interface.dart';

class CommunityRulesDialog extends StatefulWidget {
  final AgreeRulesInterface agreeRulesInterface;
  final VoidCallback onDisagree;
  final VoidCallback onAgree;

  const CommunityRulesDialog({
    super.key,
    required this.agreeRulesInterface,
    required this.onDisagree,
    required this.onAgree,
  });

  @override
  State<CommunityRulesDialog> createState() => _CommunityRulesDialogState();
}

class _CommunityRulesDialogState extends State<CommunityRulesDialog> {
  @override
  void initState() {
    super.initState();

    context.read<DocumentCubit>().getDocument(type: 'community_rules');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Row(
          children: [
            Icon(Icons.gavel, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              S.of(context).communityRules,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.6,
          child: BlocBuilder<DocumentCubit, DocumentState>(
            builder: (context, state) {
              return state.when(
                loading:
                    () => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            S.of(context).loadingTheRules,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                loaded:
                    (document) => SingleChildScrollView(
                      padding: const EdgeInsets.all(3),
                      child: ParseMarkup(text: document),
                    ),
                error:
                    (error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            S.of(context).errorLoadingRules,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<DocumentCubit>().getDocument(
                                type: 'community_rules',
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(S.of(context).repeat),
                          ),
                        ],
                      ),
                    ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: widget.onDisagree,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: Text(S.of(context).iDisagree),
          ),
          ElevatedButton(
            onPressed: widget.onAgree,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(S.of(context).iAgree),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
