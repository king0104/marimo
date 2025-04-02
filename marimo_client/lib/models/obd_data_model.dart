class ObdDataModel {
  final double? rpm; // 0C: 엔진 RPM (회전 수)
  final int? speed; // 0D: 차량 속도 (km/h)
  final double? engineLoad; // 04: 엔진 부하 계산 값 (%)
  final double? coolantTemp; // 05: 냉각수 온도 (°C)
  final double? shortTermFuelTrim; // 06: 단기 연료 트림 (%)
  final double? longTermFuelTrim; // 07: 장기 연료 트림 (%)
  final double? intakePressure; // 0B: 흡기 매니폴드 압력 (kPa)
  final double? timingAdvance; // 0E: 점화 시기 (°)
  final double? intakeTemp; // 0F: 흡입 공기 온도 (°C)
  final double? maf; // 10: MAF 공기 흐름 속도 (g/s)
  final double? throttlePosition; // 11: 스로틀 위치 (%)
  final double? fuelLevel; // 21: 연료 레벨 (%)
  final double? fuelRailPressure; // 2C: 연료 레일 압력 (kPa)
  final double? fuelTemp; // 2D: 연료 온도 (°C)
  final double? vaporPressure; // 2E: 증기 압력 (kPa)
  final double? barometricPressure; // 2F: 대기압 (kPa)
  final double? ecmTemp; // 30: ECM 온도 (°C)
  final int? distanceSinceCodesCleared; // 31: 고장코드 삭제 후 주행거리 (km)
  final double? o2SensorVoltage; // 33: O2 센서 전압 (V)
  final double? noxSensor; // 34: NOx 센서 (ppm 또는 비율)
  final double? batteryVoltage; // 3C: 배터리 전압 (V)
  final int? runTime; // 1F 또는 60: 엔진 실행 시간 (초)
  final double? controlModuleVoltage; // 42: 제어 모듈 전압 (V)
  final double? loadValue; // 43: 부하 비율 (%)
  final double? fuelInjectionTiming; // 44: 연료 주입 타이밍 (ms)
  final double? ignitionTimingAdjust; // 45: 점화 시기 조정 (°)
  final double? ambientAirTemp; // 47: 외기 온도 (°C)
  final double? fuelInjectionQuantity; // 49: 연료 주입량 (mg/str)
  final double? fuelInjectorPressure; // 4A: 연료 인젝터 압력 (kPa)
  final String? fuelType; // 4C: 연료 타입 (enum)
  final double? engineOilTemp; // 5C: 엔진 오일 온도 (°C)
  final double? fuelFilterPressure; // 62: 연료 필터 차압 (kPa)
  final double? turboPressure; // 63: 터보 압력 (kPa)
  final double? brakePressure; // 67: 브레이크 압력 (kPa)
  final int? distanceToEmpty; // 6B: 주행 가능 거리 (km)
  final double? hybridBatteryVoltage; // 8E: 하이브리드 배터리 전압 (V)
  final double? dpfTemp; // 9D: DPF 온도 (°C)
  final double? dpfPressure; // 9E: DPF 압력 (kPa)
  final String? scrStatus; // A0: SCR 상태 (enum or string)
  final double? scrTemp; // A6: SCR 온도 (°C)

  ObdDataModel({
    this.rpm,
    this.speed,
    this.engineLoad,
    this.coolantTemp,
    this.shortTermFuelTrim,
    this.longTermFuelTrim,
    this.intakePressure,
    this.timingAdvance,
    this.intakeTemp,
    this.maf,
    this.throttlePosition,
    this.fuelLevel,
    this.fuelRailPressure,
    this.fuelTemp,
    this.vaporPressure,
    this.barometricPressure,
    this.ecmTemp,
    this.o2SensorVoltage,
    this.noxSensor,
    this.batteryVoltage,
    this.runTime,
    this.controlModuleVoltage,
    this.loadValue,
    this.fuelInjectionTiming,
    this.ignitionTimingAdjust,
    this.ambientAirTemp,
    this.fuelInjectionQuantity,
    this.fuelInjectorPressure,
    this.fuelType,
    this.engineOilTemp,
    this.fuelFilterPressure,
    this.turboPressure,
    this.brakePressure,
    this.distanceToEmpty,
    this.hybridBatteryVoltage,
    this.dpfTemp,
    this.dpfPressure,
    this.scrStatus,
    this.scrTemp,
    this.distanceSinceCodesCleared,
  });

  // Optional: Add copyWith, toString, and fromJson/toJson if needed
}
