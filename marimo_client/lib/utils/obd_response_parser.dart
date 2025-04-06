import 'package:marimo_client/models/obd_data_model.dart';

/// OBD 응답 값을 파싱하여 ObdDataModel로 반환
ObdDataModel parseObdResponses(Map<String, String> responses) {
  double? parseHexToDouble(String pid, double Function(List<int>) parser) {
    final raw = responses['01$pid'];
    print('🛠 [$pid] raw = $raw');
    if (raw == null || raw.contains('NO DATA')) return null;

    try {
      final hex = raw.replaceAll(RegExp(r'[^A-Fa-f0-9]'), '');
      final startIndex = hex.indexOf('41$pid');

      if (startIndex == -1 || startIndex + 4 >= hex.length) return null;

      final dataHex = hex.substring(startIndex + 4); // '41' + '0C' 이후 데이터

      final intValues = [
        for (var i = 0; i < dataHex.length; i += 2)
          int.parse(dataHex.substring(i, i + 2), radix: 16),
      ];

      print('✅ [$pid] intValues = $intValues');

      return parser(intValues);
    } catch (e) {
      print('❌ [$pid] parse error: $e');
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

  String? parseFuelType(String pid) {
    final raw = responses['01$pid'];
    if (raw == null || raw.contains('NO DATA')) return null;

    try {
      final hex = raw.replaceAll(RegExp(r'[^A-Fa-f0-9]'), '');
      final startIndex = hex.indexOf('41$pid');
      if (startIndex == -1 || startIndex + 4 >= hex.length) return null;

      final dataHex = hex.substring(startIndex + 4);
      final value = int.parse(dataHex.substring(0, 2), radix: 16);

      const fuelTypes = {
        0x01: '가솔린',
        0x02: '메탄올',
        0x03: '에탄올',
        0x04: '디젤',
        0x05: 'LPG',
        0x06: 'CNG',
        0x07: '전기',
        0x08: '이중 연료',
        0x09: '하이브리드',
        0x0A: '바이디젤',
        0x0B: '바이퓨얼 가솔린',
        0x0C: '바이퓨얼 디젤',
        0x0D: '기타',
      };

      return fuelTypes[value] ?? '알 수 없음 ($value)';
    } catch (e) {
      return null;
    }
  }

  String? parseScrStatus(String pid) {
    final raw = responses['01$pid'];
    if (raw == null || raw.contains('NO DATA')) return null;

    try {
      final hex = raw.replaceAll(RegExp(r'[^A-Fa-f0-9]'), '');
      final startIndex = hex.indexOf('41$pid');
      if (startIndex == -1 || startIndex + 4 >= hex.length) return null;

      final dataHex = hex.substring(startIndex + 4);
      final statusCode = dataHex.substring(0, 2); // 예: '00' 또는 '40'

      switch (statusCode) {
        case '00':
          return 'SCR 비활성화';
        case '40':
          return 'SCR 활성화';
        case '80':
          return 'SCR 이상 감지';
        default:
          return '알 수 없는 상태 ($statusCode)';
      }
    } catch (e) {
      return null;
    }
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
    distanceSinceCodesCleared:
        (() {
          final raw = responses['0131'];
          if (raw == null || raw.contains('NO DATA')) return null;

          try {
            final hex = raw.replaceAll(RegExp(r'[^A-Fa-f0-9]'), '');
            final startIndex = hex.indexOf('4131'); // '41' + '31'
            if (startIndex == -1 || startIndex + 8 > hex.length) return null;

            final dataHex = hex.substring(startIndex + 4); // 실제 데이터 부분
            final bytes = [
              for (var i = 0; i < dataHex.length; i += 2)
                int.parse(dataHex.substring(i, i + 2), radix: 16),
            ];

            return bytes.length >= 2 ? bytes[0] * 256 + bytes[1] : null;
          } catch (_) {
            return null;
          }
        })(),

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
    fuelType: parseFuelType('4C'),
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
    scrStatus: parseScrStatus('A0'),
    scrTemp: parseHexToDouble('A6', (v) => v[0] - 40),
  );
}
