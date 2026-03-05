import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dio/dio.dart';
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
  Future<String>? _rulesFuture;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHtmlRules();
  }

  void _loadHtmlRules() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    _rulesFuture = Dio()
        .get<String>('https://mnapp.ru/docs/community_rules.html')
        .then((response) => response.data ?? '')
        .catchError((error) {
          setState(() {
            _hasError = true;
            _errorMessage =
                S.of(context).connectionErrorCheckYourInternetConnection;
          });
          return '';
        })
        .whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
  }

  void _retryLoading() {
    _loadHtmlRules();
  }

  Widget _buildLoadingWidget() {
    return Center(
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
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            S.of(context).errorLoadingRules,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? S.of(context).couldntLoadTheRules,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _retryLoading,
            icon: const Icon(Icons.refresh),
            label: Text(S.of(context).repeat),
          ),
        ],
      ),
    );
  }

  Widget _buildHtmlRules(String htmlContent) {
    final theme = Theme.of(context);
    final textColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(3),
      child: Html(
        data: htmlContent,
        style: {
          "body": Style(
            fontSize: FontSize(14),
            color: textColor,
            backgroundColor: Colors.transparent,
          ),
          "h1": Style(
            fontSize: FontSize(18),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          "h2": Style(
            fontSize: FontSize(16),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          "h3": Style(
            fontSize: FontSize(15),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          "h4": Style(
            fontSize: FontSize(14),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          "ul": Style(
            margin: Margins.only(top: 2, bottom: 2),
            color: textColor,
          ),
          "li": Style(
            margin: Margins.only(top: 2, bottom: 2),
            color: textColor,
          ),
          "em": Style(fontStyle: FontStyle.italic, color: textColor),
          "b": Style(fontWeight: FontWeight.bold, color: textColor),
        },
      ),
    );
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
          child:
              _isLoading
                  ? _buildLoadingWidget()
                  : (_hasError
                      ? _buildErrorWidget()
                      : FutureBuilder<String>(
                        future: _rulesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _buildLoadingWidget();
                          }
                          if (snapshot.hasError ||
                              snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return _buildErrorWidget();
                          }
                          return _buildHtmlRules(snapshot.data!);
                        },
                      )),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.onDisagree();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: Text(S.of(context).iDisagree),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onAgree();
            },
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
