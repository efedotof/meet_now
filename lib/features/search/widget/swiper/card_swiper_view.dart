import 'package:flutter/material.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/swipe/swipe_candidate_response/swipe_candidate_response.dart';

import 'card_swiper_image.dart';

class CardSwiperView extends StatelessWidget {
  final SwipeCandidateResponse item;
  final String? currentImageUrl;
  final int currentImageIndex;
  final int totalImages;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onRetry;
  final VoidCallback onImageTap;
  final VoidCallback? onInfoPressed;

  const CardSwiperView({
    super.key,
    required this.item,
    required this.currentImageUrl,
    required this.currentImageIndex,
    required this.totalImages,
    required this.isLoading,
    required this.hasError,
    required this.onNext,
    required this.onPrevious,
    required this.onRetry,
    required this.onImageTap,
    this.onInfoPressed,
  });

  String? _getRoleIconAsset() {
    final roles = item.roles;
    if (roles == null) return null;
    if (roles.contains("ADMIN") &&
        roles.contains("MODERATION") &&
        roles.contains("PREMIUM")) {
      return 'assets/amp.png';
    } else if (roles.contains("ADMIN") && roles.contains("MODERATION")) {
      return 'assets/am.png';
    } else if (roles.contains("ADMIN") && roles.contains("PREMIUM")) {
      return 'assets/ap.png';
    } else if (roles.contains("MODERATION") && roles.contains("PREMIUM")) {
      return 'assets/mp.png';
    } else if (roles.contains("ADMIN")) {
      return 'assets/administration.png';
    } else if (roles.contains("MODERATION")) {
      return 'assets/moderator.png';
    } else if (roles.contains("PREMIUM")) {
      return 'assets/prem.png';
    }
    return null;
  }

  String? _getRoleTooltipMessage(BuildContext context) {
    final roles = item.roles;
    if (roles == null) return null;
    if (roles.contains("ADMIN") &&
        roles.contains("MODERATION") &&
        roles.contains("PREMIUM")) {
      return S.of(context).administratorModeratorPremium;
    } else if (roles.contains("ADMIN") && roles.contains("MODERATION")) {
      return S.of(context).administratorModerator;
    } else if (roles.contains("ADMIN") && roles.contains("PREMIUM")) {
      return S.of(context).administratorPremium;
    } else if (roles.contains("MODERATION") && roles.contains("PREMIUM")) {
      return S.of(context).moderatorPremium;
    } else if (roles.contains("ADMIN")) {
      return S.of(context).administrator;
    } else if (roles.contains("MODERATION")) {
      return S.of(context).moderator;
    } else if (roles.contains("PREMIUM")) {
      return S.of(context).premium;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final roleIconAsset = _getRoleIconAsset();
    final roleTooltip = _getRoleTooltipMessage(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CardSwiperImage(
              imageUrl: currentImageUrl,
              totalImages: totalImages,
              isLoading: isLoading,
              hasError: hasError,
              onRetry: onRetry,
              onTap: onImageTap,
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (roleIconAsset != null && roleTooltip != null)
                      Tooltip(
                        message: roleTooltip,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Image.asset(
                            roleIconAsset,
                            width: 20,
                            height: 20,
                            filterQuality: FilterQuality.none,
                            cacheWidth: 40,
                            cacheHeight: 40,
                          ),
                        ),
                      ),
                    Text(
                      item.firstname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.age}',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),

                    if (item.verified) const SizedBox(width: 4),
                    if (item.verified)
                      Tooltip(
                        message: S.of(context).verifiedAccount,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2, left: 4),
                          child: Image.asset(
                            'assets/verify.png',
                            width: 16,
                            height: 16,
                            filterQuality: FilterQuality.none,
                            cacheWidth: 32,
                            cacheHeight: 32,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  item.city,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          if (totalImages > 1)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  totalImages,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          index == currentImageIndex
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),

          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onPrevious,
                    behavior: HitTestBehavior.opaque,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onNext,
                    behavior: HitTestBehavior.opaque,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: onInfoPressed,
            ),
          ),
        ],
      ),
    );
  }
}
