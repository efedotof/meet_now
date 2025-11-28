import 'package:flutter/material.dart';
import 'dart:async';

class ChatSwipeItem extends StatefulWidget {
  final Widget child;
  final Widget actionButtons;

  const ChatSwipeItem({
    super.key,
    required this.child,
    required this.actionButtons,
  });

  @override
  State<ChatSwipeItem> createState() => _ChatSwipeItemState();
}

class _ChatSwipeItemState extends State<ChatSwipeItem>
    with SingleTickerProviderStateMixin {
  double offset = 0;
  final double maxOffset = -120;
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _autoReturnTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);
    _controller.addListener(() {
      setState(() {
        offset = _animation.value;
      });
    });
  }

  void _animateTo(double target) {
    _autoReturnTimer?.cancel();
    _animation = Tween<double>(
      begin: offset,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(from: 0).then((_) {
      if (target == maxOffset) {
        _autoReturnTimer = Timer(const Duration(milliseconds: 1000), () {
          _animateTo(0);
        });
      }
    });
  }

  void _handleDragEnd() {
    if (offset.abs() >= maxOffset.abs() / 2) {
      _animateTo(maxOffset);
    } else {
      _animateTo(0);
    }
  }

  @override
  void dispose() {
    _autoReturnTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedOffset = (offset.abs() / maxOffset.abs()).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _autoReturnTimer?.cancel();
        _controller.stop();
        offset += details.delta.dx;
        if (offset < maxOffset) offset = maxOffset;
        if (offset > 0) offset = 0;
        setState(() {});
      },
      onHorizontalDragEnd: (_) => _handleDragEnd(),
      child: SizedBox(
        height: 80,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: Opacity(
                  opacity: normalizedOffset,
                  child: Transform.translate(
                    offset: Offset(50 * (1 - normalizedOffset), 0),
                    child: widget.actionButtons,
                  ),
                ),
              ),
            ),
            Positioned(
              left: offset,
              right: -offset,
              top: 0,
              bottom: 0,
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
