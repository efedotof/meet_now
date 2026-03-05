import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/storage/particles/particles_interface.dart';

part 'particles_state.dart';
part 'particles_cubit.freezed.dart';

class ParticlesCubit extends Cubit<ParticlesState> {
  final ParticlesInterface _particlesRepository;

  ParticlesCubit({required ParticlesInterface particlesRepository})
    : _particlesRepository = particlesRepository,
      super(ParticlesState.initial()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final isParticles = _particlesRepository.isParticles();
      emit(ParticlesState.loaded(isParticles));
    } catch (e) {
      emit(ParticlesState.error(e.toString()));
    }
  }

  Future<void> toggleParticles(bool value) async {
    try {
      await _particlesRepository.setParticles(value: value);
      emit(ParticlesState.loaded(value));
    } catch (e) {
      emit(ParticlesState.error(e.toString()));
    }
  }
}
