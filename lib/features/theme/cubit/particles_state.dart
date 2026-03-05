part of 'particles_cubit.dart';

@freezed
abstract class ParticlesState with _$ParticlesState {
  const factory ParticlesState.initial() = _Initial;
  const factory ParticlesState.loaded(bool isParticles) = _Loaded;
  const factory ParticlesState.error(String message) = _Error;
}
