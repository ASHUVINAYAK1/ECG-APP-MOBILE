import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecg_app/bloc/ecg_bloc.dart';
import 'package:ecg_app/repository/ecg_repository.dart';
import 'package:ecg_app/models/ecg_data_point.dart';

// Mock implementation of EcgRepository for testing
class MockEcgRepository implements EcgRepository {
  final StreamController<double> _controller =
      StreamController<double>.broadcast();
  final bool _isUsingRealData;

  MockEcgRepository({bool isUsingRealData = true})
    : _isUsingRealData = isUsingRealData;

  @override
  Future<void> init() async {
    // No-op for testing
  }

  @override
  Stream<double> get ecgStream => _controller.stream;

  @override
  bool get isUsingRealData => _isUsingRealData;

  @override
  void dispose() {
    _controller.close();
  }

  void addValue(double value) {
    if (!_controller.isClosed) {
      _controller.add(value);
    }
  }
}

void main() {
  group('EcgBloc Tests', () {
    test('Basic functionality test', () {
      // This is a simplified test that just verifies the bloc can be created
      // and disposed without errors
      final mockRepository = MockEcgRepository();
      final bloc = EcgBloc(repository: mockRepository);

      expect(bloc, isNotNull);

      // Clean up
      bloc.dispose();
      mockRepository.dispose();
    });
  });
}
