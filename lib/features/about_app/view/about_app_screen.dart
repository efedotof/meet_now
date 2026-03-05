import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meet_now_app/features/about_app/widget/widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:flutter/gestures.dart';

@RoutePage()
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;

          return SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child:
                        isDesktop
                            ? Center(
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 600,
                                ),
                                child: _buildContent(context, colors),
                              ),
                            )
                            : _buildContent(context, colors),
                  ),
                ),
                const AppBarWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Center(
          child: Column(
            children: [
              Text(
                'MNA',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).appTagline,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).appDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          S.of(context).appDescriptionTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(S.of(context).appDescriptionText),
        const SizedBox(height: 24),
        Text(
          S.of(context).mainFeaturesTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        FeatureItem(
          icon: '💬',
          title: S.of(context).featureBlindChatTitle,
          description: S.of(context).featureBlindChatDescription,
        ),
        FeatureItem(
          icon: '🔓',
          title: S.of(context).featureRevealProfilesTitle,
          description: S.of(context).featureRevealProfilesDescription,
        ),
        FeatureItem(
          icon: '👥',
          title: S.of(context).featureAddFriendsTitle,
          description: S.of(context).featureAddFriendsDescription,
        ),
        FeatureItem(
          icon: '📚',
          title: S.of(context).featureUserProfileTitle,
          description: S.of(context).featureUserProfileDescription,
        ),
        const SizedBox(height: 24),
        Text(
          S.of(context).additionalFeaturesTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            MyChip(label: S.of(context).chipTopics),
            MyChip(label: S.of(context).chipAvatars),
            MyChip(label: S.of(context).chipQuestionOfTheDay),
            MyChip(label: S.of(context).chipInterestMatching),
            MyChip(label: S.of(context).chipSecondChance),
            MyChip(label: S.of(context).chipMiniGames),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          S.of(context).securityTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(S.of(context).securityText),
        const SizedBox(height: 24),
        Text(
          S.of(context).technologiesTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(S.of(context).technologiesText),
        const SizedBox(height: 24),
        Text(
          S.of(context).feedbackTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.email),
          title: Text(S.of(context).supportEmailTitle),
          subtitle: Text(S.of(context).supportEmail),
          onTap: () => _launchUrl('mailto:${S.of(context).supportEmail}'),
        ),
        ListTile(
          leading: const Icon(Icons.travel_explore),
          title: Text(S.of(context).supportTelegramTitle),
          subtitle: Text(S.of(context).supportTelegram),
          onTap:
              () => _launchUrl(
                'https://t.me/${S.of(context).supportTelegram.replaceAll('@', '')}',
              ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
              children: [
                TextSpan(text: '${S.of(context).byUsingThisAppYouAgreeToOur} '),
                TextSpan(
                  text: S.of(context).termsOfUse,
                  style: TextStyle(
                    color: colors.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap =
                            () => _launchUrl(
                              'https://mnapp.ru/docs/user_agreement.pdf',
                            ),
                ),
                TextSpan(text: ' ${S.of(context).and} '),
                TextSpan(
                  text: S.of(context).privacyPolicy,
                  style: TextStyle(
                    color: colors.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap =
                            () => _launchUrl(
                              'https://mnapp.ru/docs/privacy_policy.pdf',
                            ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
