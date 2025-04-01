import 'package:marimo_client/models/obd_data_model.dart';

/// OBD 응답 값을 파싱하여 ObdDataModel로 반환
ObdDataModel parseObdResponses(Map<String, String> responses) {
  double? parseHexToDouble(String pid, double Function(List<int>) parser) {
    final raw = responses['01$pid'];
    if (raw == null || raw.contains('NO DATA')) return null;

    try {
      final bytes = raw.replaceAll(' ', '').substring(4);
      final intValues = [
        for (var i = 0; i < bytes.length; i += 2)
          int.parse(bytes.substring(i, i + 2), radix: 16),
      ];
      return parser(intValues);
    } catch (_) {
      return null;
    }
  }

  int? parseHexToInt(String pid, int Function(List<int>) parser) {
    final raw = responses['01$pid'];
    if (raw == null || raw.contains('NO DATA')) return null;

    try {
      final bytes = raw.replaceAll(' ', '').substring(4);
      final intValues = [
        for (var i = 0; i < bytes.length; i += 2)
          int.parse(bytes.substring(i, i + 2), radix: 16),
      ];
      return parser(intValues);
    } catch (_) {
      return null;
    }
  }

  String? parseString(String pid) {
    final raw = responses['01$pid'];
    if (raw == null || raw.contains('NO DATA')) return null;
    return raw.replaceAll(' ', '');
  }

  return ObdDataModel(
    rpm: parseHexToDouble('0C', (v) => ((v[0] * 256 + v[1]) / 4)),
    speed: parseHexToInt('0D', (v) => v[0]),
    engineLoad: parseHexToDouble('04', (v) => v[0] * 100 / 255),
    coolantTemp: parseHexToDouble('05', (v) => v[0] - 40),
    shortTermFuelTrim: parseHexToDouble('06', (v) => v[0] / 1.28 - 100),
    longTermFuelTrim: parseHexToDouble('07', (v) => v[0] / 1.28 - 100),
    intakePressure: parseHexToDouble('0B', (v) => v[0].toDouble()),
    timingAdvance: parseHexToDouble('0E', (v) => v[0] / 2 - 64),
    intakeTemp: parseHexToDouble('0F', (v) => v[0] - 40),
    maf: parseHexToDouble('10', (v) => (v[0] * 256 + v[1]) / 100),
    throttlePosition: parseHexToDouble('11', (v) => v[0] * 100 / 255),
    fuelLevel: parseHexToDouble('21', (v) => v[0] * 100 / 255),
    fuelRailPressure: parseHexToDouble(
      '2C',
      (v) => ((v[0] * 256 + v[1]) * 0.079),
    ),
    fuelTemp: parseHexToDouble('2D', (v) => v[0] - 40),
    vaporPressure: parseHexToDouble('2E', (v) => v[0].toDouble()),
    barometricPressure: parseHexToDouble('2F', (v) => v[0].toDouble()),
    ecmTemp: parseHexToDouble('30', (v) => v[0] - 40),
    exhaustTemp: parseHexToDouble('31', (v) => v[0] - 40),
    o2SensorVoltage: parseHexToDouble('33', (v) => v[0] / 200),
    noxSensor: parseHexToDouble('34', (v) => v[0].toDouble()),
    batteryVoltage: parseHexToDouble('3C', (v) => (v[0] * 256 + v[1]) / 1000),
    runTime: parseHexToInt('1F', (v) => v[0] * 256 + v[1]),
    controlModuleVoltage: parseHexToDouble(
      '42',
      (v) => (v[0] * 256 + v[1]) / 1000,
    ),
    loadValue: parseHexToDouble('43', (v) => v[0] * 100 / 255),
    fuelInjectionTiming: parseHexToDouble(
      '44',
      (v) => (v[0] * 256 + v[1]) / 128 - 210,
    ),
    ignitionTimingAdjust: parseHexToDouble('45', (v) => v[0] / 2 - 64),
    ambientAirTemp: parseHexToDouble('47', (v) => v[0] - 40),
    fuelInjectionQuantity: parseHexToDouble('49', (v) => v[0].toDouble()),
    fuelInjectorPressure: parseHexToDouble('4A', (v) => v[0].toDouble()),
    fuelType: parseString('4C'),
    engineOilTemp: parseHexToDouble('30', (v) => v[0] - 40),
    fuelFilterPressure: parseHexToDouble('62', (v) => v[0].toDouble()),
    turboPressure: parseHexToDouble('63', (v) => v[0].toDouble()),
    brakePressure: parseHexToDouble('67', (v) => v[0].toDouble()),
    distanceToEmpty: parseHexToInt('6B', (v) => v[0]),
    hybridBatteryVoltage: parseHexToDouble(
      '8E',
      (v) => (v[0] * 256 + v[1]) / 100,
    ),
    dpfTemp: parseHexToDouble('9D', (v) => v[0] - 40),
    dpfPressure: parseHexToDouble('9E', (v) => v[0].toDouble()),
    scrStatus: parseString('A0'),
    scrTemp: parseHexToDouble('A6', (v) => v[0] - 40),
  );
}
