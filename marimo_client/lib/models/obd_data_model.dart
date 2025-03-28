class ObdDataModel {
  final double? rpm; // 엔진 RPM (회전 수)
  final int? speed; // 차량 속도 (km/h)
  final double? engineLoad; // 엔진 부하 (%)
  final double? coolantTemp; // 냉각수 온도 (°C)
  final double? throttlePosition; // 스로틀 포지션 (%)
  final double? intakeTemp; // 흡기 온도 (°C)
  final double? maf; // MAF 공기 유량 (g/s)
  final double? fuelLevel; // 연료 잔량 (%)
  final double? timingAdvance; // 점화 타이밍 조절 (°)
  final double? barometricPressure; // 기압 (kPa)
  final double? ambientAirTemp; // 외기 온도 (°C)
  final double? fuelPressure; // 연료 압력 (kPa)
  final double? intakePressure; // 흡기 매니폴드 압력 (kPa)
  final int? runTime; // 엔진 작동 시간 (초)
  final int? distanceSinceCodesCleared; // DTC 클리어 후 주행 거리 (km)
  final int? distanceWithMIL; // MIL(체크엔진) 후 주행 거리 (km)
  final String? fuelType; // 연료 종류 (가솔린, 디젤 등)
  final double? engineOilTemp; // 엔진 오일 온도 (°C)

  ObdDataModel({
    this.rpm,
    this.speed,
    this.engineLoad,
    this.coolantTemp,
    this.throttlePosition,
    this.intakeTemp,
    this.maf,
    this.fuelLevel,
    this.timingAdvance,
    this.barometricPressure,
    this.ambientAirTemp,
    this.fuelPressure,
    this.intakePressure,
    this.runTime,
    this.distanceSinceCodesCleared,
    this.distanceWithMIL,
    this.fuelType,
    this.engineOilTemp,
  });

  ObdDataModel copyWith({
    double? rpm,
    int? speed,
    double? engineLoad,
    double? coolantTemp,
    double? throttlePosition,
    double? intakeTemp,
    double? maf,
    double? fuelLevel,
    double? timingAdvance,
    double? barometricPressure,
    double? ambientAirTemp,
    double? fuelPressure,
    double? intakePressure,
    int? runTime,
    int? distanceSinceCodesCleared,
    int? distanceWithMIL,
    String? fuelType,
    double? engineOilTemp,
  }) {
    return ObdDataModel(
      rpm: rpm ?? this.rpm,
      speed: speed ?? this.speed,
      engineLoad: engineLoad ?? this.engineLoad,
      coolantTemp: coolantTemp ?? this.coolantTemp,
      throttlePosition: throttlePosition ?? this.throttlePosition,
      intakeTemp: intakeTemp ?? this.intakeTemp,
      maf: maf ?? this.maf,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      timingAdvance: timingAdvance ?? this.timingAdvance,
      barometricPressure: barometricPressure ?? this.barometricPressure,
      ambientAirTemp: ambientAirTemp ?? this.ambientAirTemp,
      fuelPressure: fuelPressure ?? this.fuelPressure,
      intakePressure: intakePressure ?? this.intakePressure,
      runTime: runTime ?? this.runTime,
      distanceSinceCodesCleared:
          distanceSinceCodesCleared ?? this.distanceSinceCodesCleared,
      distanceWithMIL: distanceWithMIL ?? this.distanceWithMIL,
      fuelType: fuelType ?? this.fuelType,
      engineOilTemp: engineOilTemp ?? this.engineOilTemp,
    );
  }

  @override
  String toString() {
    return '''
ObdDataModel(
  rpm: $rpm,
  speed: $speed,
  engineLoad: $engineLoad,
  coolantTemp: $coolantTemp,
  throttlePosition: $throttlePosition,
  intakeTemp: $intakeTemp,
  maf: $maf,
  fuelLevel: $fuelLevel,
  timingAdvance: $timingAdvance,
  barometricPressure: $barometricPressure,
  ambientAirTemp: $ambientAirTemp,
  fuelPressure: $fuelPressure,
  intakePressure: $intakePressure,
  runTime: $runTime,
  distanceSinceCodesCleared: $distanceSinceCodesCleared,
  distanceWithMIL: $distanceWithMIL,
  fuelType: $fuelType,
  engineOilTemp: $engineOilTemp
)''';
  }
}
