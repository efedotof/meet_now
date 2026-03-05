import 'dart:math';
import 'package:flutter/material.dart';
import 'season_particles.dart';
import 'season_utils.dart';

class SeasonBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final bool enabled;
  final Season? season;

  const SeasonBackground({
    super.key,
    required this.child,
    this.particleCount = 20,
    this.enabled = true,
    this.season,
  });

  @override
  State<SeasonBackground> createState() => _SeasonBackgroundState();
}

class _SeasonBackgroundState extends State<SeasonBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<SeasonParticle> _particles;
  final Random _random = Random();
  DateTime _lastUpdate = DateTime.now();
  late Season _currentSeason;

  @override
  void initState() {
    super.initState();
    _currentSeason = widget.season ?? SeasonUtils.getCurrentSeason();

    _controller = AnimationController(
      duration: const Duration(days: 1),
      vsync: this,
    )..repeat();

    _particles = [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeParticles();
      }
    });
  }

  @override
  void didUpdateWidget(SeasonBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.season != widget.season ||
        oldWidget.particleCount != widget.particleCount) {
      _currentSeason = widget.season ?? SeasonUtils.getCurrentSeason();
      _initializeParticles();
    }
  }

  void _initializeParticles() {
    final size = MediaQuery.sizeOf(context);
    final color = SeasonUtils.getSeasonColor(_currentSeason);

    _particles = List.generate(widget.particleCount, (index) {
      final position = Offset(
        _random.nextDouble() * size.width,
        _random.nextDouble() * size.height,
      );

      switch (_currentSeason) {
        case Season.winter:
          return KochSnowflakeParticle(
            position: position,
            size: 15 + _random.nextDouble() * 25,
            speed: 0.5 + _random.nextDouble() * 1.5,
            color: color,
            rotation: _random.nextDouble() * 2 * pi,
            rotationSpeed: _random.nextDouble() * 0.5 - 0.25,
            opacity: 0.5 + _random.nextDouble() * 0.5,
            oscillation: _random.nextDouble() * 2 * pi,
            oscillationSpeed: 0.5 + _random.nextDouble() * 1.0,
          );

        case Season.spring:
          return FlowerPetalParticle(
            position: position,
            size: 20 + _random.nextDouble() * 20,
            speed: 0.3 + _random.nextDouble() * 0.7,
            color: color,
            rotation: _random.nextDouble() * 2 * pi,
            rotationSpeed: _random.nextDouble() * 0.3 - 0.15,
            opacity: 0.4 + _random.nextDouble() * 0.4,
            oscillation: _random.nextDouble() * 2 * pi,
            oscillationSpeed: 0.3 + _random.nextDouble() * 0.7,
          );

        case Season.summer:
          return SunParticle(
            position: position,
            size: 25 + _random.nextDouble() * 20,
            speed: 0.2 + _random.nextDouble() * 0.5,
            color: color,
            rotation: _random.nextDouble() * 2 * pi,
            rotationSpeed: _random.nextDouble() * 0.2 - 0.1,
            opacity: 0.6 + _random.nextDouble() * 0.4,
            oscillation: _random.nextDouble() * 2 * pi,
            oscillationSpeed: 0.2 + _random.nextDouble() * 0.5,
            glowIntensity: 0.3 + _random.nextDouble() * 0.7,
          );

        case Season.autumn:
          return LeafParticle(
            position: position,
            size: 30 + _random.nextDouble() * 20,
            speed: 0.4 + _random.nextDouble() * 1.0,
            color: color,
            rotation: _random.nextDouble() * 2 * pi,
            rotationSpeed: _random.nextDouble() * 0.4 - 0.2,
            opacity: 0.5 + _random.nextDouble() * 0.5,
            oscillation: _random.nextDouble() * 2 * pi,
            oscillationSpeed: 0.4 + _random.nextDouble() * 0.8,
          );
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  void _updateParticles() {
    if (!widget.enabled || _particles.isEmpty) return;

    final now = DateTime.now();
    final deltaTime = now.difference(_lastUpdate).inMilliseconds / 1000.0;
    _lastUpdate = now;

    final size = MediaQuery.sizeOf(context);

    for (final particle in _particles) {
      particle.update(deltaTime, size.height, size.width);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _updateParticles();
        return CustomPaint(
          painter: SeasonBackgroundPainter(particles: _particles),
          child: widget.child,
        );
      },
    );
  }
}

class SeasonBackgroundPainter extends CustomPainter {
  final List<SeasonParticle> particles;

  SeasonBackgroundPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      particle.draw(canvas, Paint());
    }
  }

  @override
  bool shouldRepaint(SeasonBackgroundPainter oldDelegate) => true;
}
