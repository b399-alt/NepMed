import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// SensorService — singleton that manages all hardware sensor listeners.
///
/// Features:
///  1. Shake detection  → calls [onShake]
///  2. Step counting    → exposed via [steps] / [stepsStream]
///  3. Tilt detection   → calls [onTilt] when device tilts > threshold
class SensorService extends ChangeNotifier {
  // ─── Singleton ────────────────────────────────────────────────────────────
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  // ─── Subscriptions ────────────────────────────────────────────────────────
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<UserAccelerometerEvent>? _userAccelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  // ─── Shake state ──────────────────────────────────────────────────────────
  static const double _shakeThreshold = 18.0; // m/s² — above normal gravity
  static const int _shakeMinCount = 3;         // shakes needed in window
  static const int _shakeWindowMs = 2000;      // rolling window (ms)
  static const int _cooldownMs = 3000;         // ignore shakes during cooldown

  int _shakeCount = 0;
  DateTime? _firstShakeTime;
  DateTime? _lastShakeFired;

  // ─── Step counter ─────────────────────────────────────────────────────────
  int _steps = 0;
  bool _wasAboveThreshold = false;
  static const double _stepLowThreshold = 0.4;
  static const double _stepHighThreshold = 1.0;

  final StreamController<int> _stepsController =
      StreamController<int>.broadcast();

  // ─── Tilt state ───────────────────────────────────────────────────────────
  static const double _tiltThreshold = 1.8; // rad/s for gyroscope
  DateTime? _lastTiltFired;
  static const int _tiltCooldownMs = 1200;

  // ─── Callbacks ────────────────────────────────────────────────────────────
  VoidCallback? onShake;
  void Function(TiltDirection dir)? onTilt;

  // ─── Public API ───────────────────────────────────────────────────────────
  int get steps => _steps;
  Stream<int> get stepsStream => _stepsController.stream;

  bool _active = false;
  bool get isActive => _active;

  void startAll({
    VoidCallback? onShakeCallback,
    void Function(TiltDirection dir)? onTiltCallback,
  }) {
    if (_active) return;
    _active = true;
    onShake = onShakeCallback;
    onTilt = onTiltCallback;

    _startShakeDetection();
    _startStepCounting();
    _startTiltDetection();
  }

  void stopAll() {
    _accelSub?.cancel();
    _userAccelSub?.cancel();
    _gyroSub?.cancel();
    _active = false;
  }

  void resetSteps() {
    _steps = 0;
    _stepsController.add(_steps);
    notifyListeners();
  }

  // ─── Shake Detection (Accelerometer) ──────────────────────────────────────
  void _startShakeDetection() {
    _accelSub = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onAccelerometer);
  }

  void _onAccelerometer(AccelerometerEvent e) {
    // Net magnitude (subtract ~gravity component roughly)
    final magnitude = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
    final net = (magnitude - 9.8).abs();

    if (net < _shakeThreshold) return;

    final now = DateTime.now();

    // Cooldown — don't fire twice quickly
    if (_lastShakeFired != null &&
        now.difference(_lastShakeFired!).inMilliseconds < _cooldownMs) {
      return;
    }

    // Rolling window reset
    if (_firstShakeTime == null ||
        now.difference(_firstShakeTime!).inMilliseconds > _shakeWindowMs) {
      _shakeCount = 0;
      _firstShakeTime = now;
    }

    _shakeCount++;
    if (_shakeCount >= _shakeMinCount) {
      _shakeCount = 0;
      _lastShakeFired = now;
      onShake?.call();
    }
  }

  // ─── Step Counting (UserAccelerometer) ────────────────────────────────────
  void _startStepCounting() {
    _userAccelSub = userAccelerometerEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen(_onUserAccel);
  }

  void _onUserAccel(UserAccelerometerEvent e) {
    // Magnitude of linear acceleration (gravity removed)
    final mag = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);

    // Peak detection: step = crossing up through high then back down below low
    if (!_wasAboveThreshold && mag > _stepHighThreshold) {
      _wasAboveThreshold = true;
    } else if (_wasAboveThreshold && mag < _stepLowThreshold) {
      _wasAboveThreshold = false;
      _steps++;
      _stepsController.add(_steps);
      notifyListeners();
    }
  }

  // ─── Tilt Detection (Gyroscope) ───────────────────────────────────────────
  void _startTiltDetection() {
    _gyroSub = gyroscopeEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onGyroscope);
  }

  void _onGyroscope(GyroscopeEvent e) {
    final now = DateTime.now();
    if (_lastTiltFired != null &&
        now.difference(_lastTiltFired!).inMilliseconds < _tiltCooldownMs) {
      return;
    }

    if (e.y.abs() > _tiltThreshold) {
      _lastTiltFired = now;
      onTilt?.call(e.y > 0 ? TiltDirection.right : TiltDirection.left);
    }
  }

  @override
  void dispose() {
    stopAll();
    _stepsController.close();
    super.dispose();
  }
}

enum TiltDirection { left, right }
