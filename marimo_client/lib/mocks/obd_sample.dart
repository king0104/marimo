import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const List<Map<String, dynamic>> rawObdSample = [
  {"id": 1, "car_id": 12, "code": "NO RESPONSE", "pid": "0100"},
  {"id": 2, "car_id": 12, "code": "STOPPED", "pid": "0101"},
  {"id": 3, "car_id": 12, "code": "SEARCHING...\nNO DATA", "pid": "0102"},
  {"id": 4, "car_id": 12, "code": "7E80441030200", "pid": "0103"},
  {"id": 5, "car_id": 12, "code": "7E903410421\n7E803410421", "pid": "0104"},
  {"id": 6, "car_id": 12, "code": "7E903410577", "pid": "0105"},
  {"id": 7, "car_id": 12, "code": "7E803410684", "pid": "0106"},
  {"id": 8, "car_id": 12, "code": "7E803410779", "pid": "0107"},
  {"id": 9, "car_id": 12, "code": "NO DATA", "pid": "0108"},
  {"id": 10, "car_id": 12, "code": "NO DATA", "pid": "0109"},
  {"id": 11, "car_id": 12, "code": "NO DATA", "pid": "010A"},
  {"id": 12, "car_id": 12, "code": "7E803410B24", "pid": "010B"},
  {
    "id": 13,
    "car_id": 12,
    "code": "7E804410C0B86\n7EE04410C0B86\n7E904410C0B86",
    "pid": "010C",
  },
  {"id": 14, "car_id": 12, "code": "7E803410D00\n7E903410D00", "pid": "010D"},
  {"id": 15, "car_id": 12, "code": "7E803410E7B", "pid": "010E"},
  {"id": 16, "car_id": 12, "code": "7E803410F3E", "pid": "010F"},
  {"id": 17, "car_id": 12, "code": "7E804411000D3", "pid": "0110"},
  {"id": 18, "car_id": 12, "code": "7E903411120\n7E803411120", "pid": "0111"},
  {"id": 19, "car_id": 12, "code": "NO DATA", "pid": "0112"},
  {"id": 20, "car_id": 12, "code": "7E803411303", "pid": "0113"},
  {"id": 21, "car_id": 12, "code": "NO DATA", "pid": "0114"},
  {"id": 22, "car_id": 12, "code": "7E804411550FF", "pid": "0115"},
  {"id": 23, "car_id": 12, "code": "NO DATA", "pid": "0116"},
  {"id": 24, "car_id": 12, "code": "NO DATA", "pid": "0117"},
  {"id": 25, "car_id": 12, "code": "NO DATA", "pid": "0118"},
  {"id": 26, "car_id": 12, "code": "NO DATA", "pid": "0119"},
  {"id": 27, "car_id": 12, "code": "NO DATA", "pid": "011A"},
  {"id": 28, "car_id": 12, "code": "NO DATA", "pid": "011B"},
  {"id": 29, "car_id": 12, "code": "7E903411C03\n7E803411C1E", "pid": "011C"},
  {"id": 30, "car_id": 12, "code": "NO DATA", "pid": "011D"},
  {"id": 31, "car_id": 12, "code": "NO DATA", "pid": "011E"},
  {
    "id": 32,
    "car_id": 12,
    "code": "7E904411F0227\n7E804411F0227",
    "pid": "011F",
  },
  {
    "id": 33,
    "car_id": 12,
    "code": "7EE06412000018001\n7E906412080018001\n7E8064120A01FF011",
    "pid": "0120",
  },
  {
    "id": 34,
    "car_id": 12,
    "code": "7E90441210000\n7E80441210000",
    "pid": "0121",
  },
  {"id": 35, "car_id": 12, "code": "NO DATA", "pid": "0122"},
  {"id": 36, "car_id": 12, "code": "7E80441230310", "pid": "0123"},
  {"id": 37, "car_id": 12, "code": "NO DATA", "pid": "0124"},
  {"id": 38, "car_id": 12, "code": "NO DATA", "pid": "0125"},
  {"id": 39, "car_id": 12, "code": "NO DATA", "pid": "0126"},
  {"id": 40, "car_id": 12, "code": "NO DATA", "pid": "0127"},
  {"id": 41, "car_id": 12, "code": "NO DATA", "pid": "0128"},
  {"id": 42, "car_id": 12, "code": "NO DATA", "pid": "0129"},
  {"id": 43, "car_id": 12, "code": "NO DATA", "pid": "012A"},
  {"id": 44, "car_id": 12, "code": "NO DATA", "pid": "012B"},
  {"id": 45, "car_id": 12, "code": "7E803412C00", "pid": "012C"},
  {"id": 46, "car_id": 12, "code": "7E803412D80", "pid": "012D"},
  {"id": 47, "car_id": 12, "code": "7E803412E48", "pid": "012E"},
  {"id": 48, "car_id": 12, "code": "7E803412F44", "pid": "012F"},
  {
    "id": 49,
    "car_id": 12,
    "code": "7EE034130F1\n7E9034130F1\n7E8034130F1",
    "pid": "0130",
  },
  {
    "id": 50,
    "car_id": 12,
    "code": "7E904413135B4\n7EE044131365C\n7E804413136F8",
    "pid": "0131",
  },
  {"id": 51, "car_id": 12, "code": "7E8044132F922", "pid": "0132"},
  {"id": 52, "car_id": 12, "code": "7E803413363", "pid": "0133"},
  {"id": 53, "car_id": 12, "code": "7E80641347FF77FFB", "pid": "0134"},
  {"id": 54, "car_id": 12, "code": "NO DATA", "pid": "0135"},
  {"id": 55, "car_id": 12, "code": "NO DATA", "pid": "0136"},
  {"id": 56, "car_id": 12, "code": "NO DATA", "pid": "0137"},
  {"id": 57, "car_id": 12, "code": "NO DATA", "pid": "0138"},
  {"id": 58, "car_id": 12, "code": "NO DATA", "pid": "0139"},
  {"id": 59, "car_id": 12, "code": "NO DATA", "pid": "013A"},
  {"id": 60, "car_id": 12, "code": "NO DATA", "pid": "013B"},
  {"id": 61, "car_id": 12, "code": "7E804413C0DC3", "pid": "013C"},
  {"id": 62, "car_id": 12, "code": "NO DATA", "pid": "013D"},
  {"id": 63, "car_id": 12, "code": "NO DATA", "pid": "013E"},
  {"id": 64, "car_id": 12, "code": "NO DATA", "pid": "013F"},
  {
    "id": 65,
    "car_id": 12,
    "code": "7EE06414080000000\n7E9064140C0800000\n7E8064140FED08C01",
    "pid": "0140",
  },
  {
    "id": 66,
    "car_id": 12,
    "code": "7EE06414100040000\n7E906414100040000\n7E80641410007E5A5",
    "pid": "0141",
  },
  {
    "id": 67,
    "car_id": 12,
    "code": "7E9044142391D\n7E804414239AD",
    "pid": "0142",
  },
  {"id": 68, "car_id": 12, "code": "7E8044143003D", "pid": "0143"},
  {"id": 69, "car_id": 12, "code": "7E80441447FFF", "pid": "0144"},
  {"id": 70, "car_id": 12, "code": "7E803414506", "pid": "0145"},
  {"id": 71, "car_id": 12, "code": "7E80341463D", "pid": "0146"},
  {"id": 72, "car_id": 12, "code": "7E80341471F", "pid": "0147"},
  {"id": 73, "car_id": 12, "code": "NO DATA", "pid": "0148"},
  {"id": 74, "car_id": 12, "code": "7E903414900\n7E803414925", "pid": "0149"},
  {"id": 75, "car_id": 12, "code": "7E803414A12", "pid": "014A"},
  {"id": 76, "car_id": 12, "code": "NO DATA", "pid": "014B"},
  {"id": 77, "car_id": 12, "code": "7E803414C09", "pid": "014C"},
  {"id": 78, "car_id": 12, "code": "NO DATA", "pid": "014D"},
  {"id": 79, "car_id": 12, "code": "NO DATA", "pid": "014E"},
  {"id": 80, "car_id": 12, "code": "NO DATA", "pid": "014F"},
  {"id": 81, "car_id": 12, "code": "NO DATA", "pid": "0150"},
  {"id": 82, "car_id": 12, "code": "7E803415101", "pid": "0151"},
  {"id": 83, "car_id": 12, "code": "NO DATA", "pid": "0152"},
  {"id": 84, "car_id": 12, "code": "NO DATA", "pid": "0153"},
  {"id": 85, "car_id": 12, "code": "NO DATA", "pid": "0154"},
  {"id": 86, "car_id": 12, "code": "7E803415580", "pid": "0155"},
  {"id": 87, "car_id": 12, "code": "7E803415680", "pid": "0156"},
  {"id": 88, "car_id": 12, "code": "NO DATA", "pid": "0157"},
  {"id": 89, "car_id": 12, "code": "NO DATA", "pid": "0158"},
  {"id": 90, "car_id": 12, "code": "NO DATA", "pid": "0159"},
  {"id": 91, "car_id": 12, "code": "NO DATA", "pid": "015A"},
  {"id": 92, "car_id": 12, "code": "NO DATA", "pid": "015B"},
  {"id": 93, "car_id": 12, "code": "NO DATA", "pid": "015C"},
  {"id": 94, "car_id": 12, "code": "NO DATA", "pid": "015D"},
  {"id": 95, "car_id": 12, "code": "NO DATA", "pid": "015E"},
  {"id": 96, "car_id": 12, "code": "NO DATA", "pid": "015F"},
  {"id": 97, "car_id": 12, "code": "7E806416062200001", "pid": "0160"},
  {"id": 98, "car_id": 12, "code": "NO DATA", "pid": "0161"},
  {"id": 99, "car_id": 12, "code": "7E803416282", "pid": "0162"},
  {"id": 100, "car_id": 12, "code": "7E8044163015E", "pid": "0163"},
  {"id": 101, "car_id": 12, "code": "NO DATA", "pid": "0164"},
  {"id": 102, "car_id": 12, "code": "NO DATA", "pid": "0165"},
  {"id": 103, "car_id": 12, "code": "NO DATA", "pid": "0166"},
  {"id": 104, "car_id": 12, "code": "7E8054167036A5B", "pid": "0167"},
  {"id": 105, "car_id": 12, "code": "NO DATA", "pid": "0168"},
  {"id": 106, "car_id": 12, "code": "NO DATA", "pid": "0169"},
  {"id": 107, "car_id": 12, "code": "NO DATA", "pid": "016A"},
  {"id": 108, "car_id": 12, "code": "7E807416B1014000000", "pid": "016B"},
  {"id": 109, "car_id": 12, "code": "NO DATA", "pid": "016C"},
  {"id": 110, "car_id": 12, "code": "NO DATA", "pid": "016D"},
  {"id": 111, "car_id": 12, "code": "NO DATA", "pid": "016E"},
  {"id": 112, "car_id": 12, "code": "NO DATA", "pid": "016F"},
  {"id": 113, "car_id": 12, "code": "NO DATA", "pid": "0170"},
  {"id": 114, "car_id": 12, "code": "NO DATA", "pid": "0171"},
  {"id": 115, "car_id": 12, "code": "NO DATA", "pid": "0172"},
  {"id": 116, "car_id": 12, "code": "NO DATA", "pid": "0173"},
  {"id": 117, "car_id": 12, "code": "NO DATA", "pid": "0174"},
  {"id": 118, "car_id": 12, "code": "NO DATA", "pid": "0175"},
  {"id": 119, "car_id": 12, "code": "NO DATA", "pid": "0176"},
  {"id": 120, "car_id": 12, "code": "NO DATA", "pid": "0177"},
  {"id": 121, "car_id": 12, "code": "NO DATA", "pid": "0178"},
  {"id": 122, "car_id": 12, "code": "NO DATA", "pid": "0179"},
  {"id": 123, "car_id": 12, "code": "NO DATA", "pid": "017A"},
  {"id": 124, "car_id": 12, "code": "NO DATA", "pid": "017B"},
  {"id": 125, "car_id": 12, "code": "NO DATA", "pid": "017C"},
  {"id": 126, "car_id": 12, "code": "NO DATA", "pid": "017D"},
  {"id": 127, "car_id": 12, "code": "NO DATA", "pid": "017E"},
  {"id": 128, "car_id": 12, "code": "NO DATA", "pid": "017F"},
  {"id": 129, "car_id": 12, "code": "7E80641800004000D", "pid": "0180"},
  {"id": 130, "car_id": 12, "code": "NO DATA", "pid": "0181"},
  {"id": 131, "car_id": 12, "code": "NO DATA", "pid": "0182"},
  {"id": 132, "car_id": 12, "code": "NO DATA", "pid": "0183"},
  {"id": 133, "car_id": 12, "code": "NO DATA", "pid": "0184"},
  {"id": 134, "car_id": 12, "code": "NO DATA", "pid": "0185"},
  {"id": 135, "car_id": 12, "code": "NO DATA", "pid": "0186"},
  {"id": 136, "car_id": 12, "code": "NO DATA", "pid": "0187"},
  {"id": 137, "car_id": 12, "code": "NO DATA", "pid": "0188"},
  {"id": 138, "car_id": 12, "code": "NO DATA", "pid": "0189"},
  {"id": 139, "car_id": 12, "code": "NO DATA", "pid": "018A"},
  {"id": 140, "car_id": 12, "code": "NO DATA", "pid": "018B"},
  {"id": 141, "car_id": 12, "code": "NO DATA", "pid": "018C"},
  {"id": 142, "car_id": 12, "code": "NO DATA", "pid": "018D"},
  {"id": 143, "car_id": 12, "code": "7E803418E81", "pid": "018E"},
  {"id": 144, "car_id": 12, "code": "NO DATA", "pid": "018F"},
  {"id": 145, "car_id": 12, "code": "NO DATA", "pid": "0190"},
  {"id": 146, "car_id": 12, "code": "NO DATA", "pid": "0191"},
  {"id": 147, "car_id": 12, "code": "NO DATA", "pid": "0192"},
  {"id": 148, "car_id": 12, "code": "NO DATA", "pid": "0193"},
  {"id": 149, "car_id": 12, "code": "NO DATA", "pid": "0194"},
  {"id": 150, "car_id": 12, "code": "NO DATA", "pid": "0195"},
  {"id": 151, "car_id": 12, "code": "NO DATA", "pid": "0196"},
  {"id": 152, "car_id": 12, "code": "NO DATA", "pid": "0197"},
  {"id": 153, "car_id": 12, "code": "NO DATA", "pid": "0198"},
  {"id": 154, "car_id": 12, "code": "NO DATA", "pid": "0199"},
  {"id": 155, "car_id": 12, "code": "NO DATA", "pid": "019A"},
  {"id": 156, "car_id": 12, "code": "NO DATA", "pid": "019B"},
  {"id": 157, "car_id": 12, "code": "NO DATA", "pid": "019C"},
  {"id": 158, "car_id": 12, "code": "7E806419D00070007", "pid": "019D"},
  {"id": 159, "car_id": 12, "code": "7E804419E0033", "pid": "019E"},
  {"id": 160, "car_id": 12, "code": "NO DATA", "pid": "019F"},
  {"id": 161, "car_id": 12, "code": "7E80641A004000000", "pid": "01A0"},
  {"id": 162, "car_id": 12, "code": "NO DATA", "pid": "01A1"},
  {"id": 163, "car_id": 12, "code": "NO DATA", "pid": "01A2"},
  {"id": 164, "car_id": 12, "code": "NO DATA", "pid": "01A3"},
  {"id": 165, "car_id": 12, "code": "NO DATA", "pid": "01A4"},
  {"id": 166, "car_id": 12, "code": "NO DATA", "pid": "01A5"},
  {"id": 167, "car_id": 12, "code": "7E80641A600022B79", "pid": "01A6"},
  {"id": 168, "car_id": 12, "code": "NO DATA", "pid": "01A7"},
  {"id": 169, "car_id": 12, "code": "NO DATA", "pid": "01A8"},
  {"id": 170, "car_id": 12, "code": "NO DATA", "pid": "01A9"},
  {"id": 171, "car_id": 12, "code": "NO DATA", "pid": "01AA"},
  {"id": 172, "car_id": 12, "code": "NO DATA", "pid": "01AB"},
  {"id": 173, "car_id": 12, "code": "NO DATA", "pid": "01AC"},
  {"id": 174, "car_id": 12, "code": "NO DATA", "pid": "01AD"},
  {"id": 175, "car_id": 12, "code": "NO DATA", "pid": "01AE"},
  {"id": 176, "car_id": 12, "code": "NO DATA", "pid": "01AF"},
  {"id": 177, "car_id": 12, "code": "NO DATA", "pid": "01B0"},
  {"id": 178, "car_id": 12, "code": "NO DATA", "pid": "01B1"},
  {"id": 179, "car_id": 12, "code": "NO DATA", "pid": "01B2"},
  {"id": 180, "car_id": 12, "code": "NO DATA", "pid": "01B3"},
  {"id": 181, "car_id": 12, "code": "NO DATA", "pid": "01B4"},
  {"id": 182, "car_id": 12, "code": "NO DATA", "pid": "01B5"},
  {"id": 183, "car_id": 12, "code": "NO DATA", "pid": "01B6"},
  {"id": 184, "car_id": 12, "code": "NO DATA", "pid": "01B7"},
  {"id": 185, "car_id": 12, "code": "NO DATA", "pid": "01B8"},
  {"id": 186, "car_id": 12, "code": "NO DATA", "pid": "01B9"},
  {"id": 187, "car_id": 12, "code": "NO DATA", "pid": "01BA"},
  {"id": 188, "car_id": 12, "code": "NO DATA", "pid": "01BB"},
  {"id": 189, "car_id": 12, "code": "NO DATA", "pid": "01BC"},
  {"id": 190, "car_id": 12, "code": "NO DATA", "pid": "01BD"},
  {"id": 191, "car_id": 12, "code": "NO DATA", "pid": "01BE"},
  {"id": 192, "car_id": 12, "code": "NO DATA", "pid": "01BF"},
  {"id": 193, "car_id": 12, "code": "NO DATA", "pid": "01C0"},
  {"id": 194, "car_id": 12, "code": "NO DATA", "pid": "01C1"},
  {"id": 195, "car_id": 12, "code": "NO DATA", "pid": "01C2"},
  {"id": 196, "car_id": 12, "code": "NO DATA", "pid": "01C3"},
  {"id": 197, "car_id": 12, "code": "NO DATA", "pid": "01C4"},
  {"id": 198, "car_id": 12, "code": "NO DATA", "pid": "01C5"},
  {"id": 199, "car_id": 12, "code": "NO DATA", "pid": "01C6"},
  {"id": 200, "car_id": 12, "code": "NO DATA", "pid": "01C7"},
  {"id": 201, "car_id": 12, "code": "NO DATA", "pid": "01C8"},
  {"id": 202, "car_id": 12, "code": "NO DATA", "pid": "01C9"},
  {"id": 203, "car_id": 12, "code": "NO DATA", "pid": "01CA"},
  {"id": 204, "car_id": 12, "code": "NO DATA", "pid": "01CB"},
  {"id": 205, "car_id": 12, "code": "NO DATA", "pid": "01CC"},
  {"id": 206, "car_id": 12, "code": "NO DATA", "pid": "01CD"},
  {"id": 207, "car_id": 12, "code": "NO DATA", "pid": "01CE"},
  {"id": 208, "car_id": 12, "code": "NO DATA", "pid": "01CF"},
  {"id": 209, "car_id": 12, "code": "NO DATA", "pid": "01D0"},
  {"id": 210, "car_id": 12, "code": "NO DATA", "pid": "01D1"},
  {"id": 211, "car_id": 12, "code": "NO DATA", "pid": "01D2"},
  {"id": 212, "car_id": 12, "code": "NO DATA", "pid": "01D3"},
  {"id": 213, "car_id": 12, "code": "NO DATA", "pid": "01D4"},
  {"id": 214, "car_id": 12, "code": "NO DATA", "pid": "01D5"},
  {"id": 215, "car_id": 12, "code": "NO DATA", "pid": "01D6"},
  {"id": 216, "car_id": 12, "code": "NO DATA", "pid": "01D7"},
  {"id": 217, "car_id": 12, "code": "NO DATA", "pid": "01D8"},
  {"id": 218, "car_id": 12, "code": "NO DATA", "pid": "01D9"},
  {"id": 219, "car_id": 12, "code": "NO DATA", "pid": "01DA"},
  {"id": 220, "car_id": 12, "code": "NO DATA", "pid": "01DB"},
  {"id": 221, "car_id": 12, "code": "NO DATA", "pid": "01DC"},
  {"id": 222, "car_id": 12, "code": "NO DATA", "pid": "01DD"},
  {"id": 223, "car_id": 12, "code": "NO DATA", "pid": "01DE"},
  {"id": 224, "car_id": 12, "code": "NO DATA", "pid": "01DF"},
  {"id": 225, "car_id": 12, "code": "NO DATA", "pid": "01E0"},
  {"id": 226, "car_id": 12, "code": "NO DATA", "pid": "01E1"},
  {"id": 227, "car_id": 12, "code": "NO DATA", "pid": "01E2"},
  {"id": 228, "car_id": 12, "code": "NO DATA", "pid": "01E3"},
  {"id": 229, "car_id": 12, "code": "NO DATA", "pid": "01E4"},
  {"id": 230, "car_id": 12, "code": "NO DATA", "pid": "01E5"},
  {"id": 231, "car_id": 12, "code": "NO DATA", "pid": "01E6"},
  {"id": 232, "car_id": 12, "code": "NO DATA", "pid": "01E7"},
  {"id": 233, "car_id": 12, "code": "NO DATA", "pid": "01E8"},
  {"id": 234, "car_id": 12, "code": "NO DATA", "pid": "01E9"},
  {"id": 235, "car_id": 12, "code": "NO DATA", "pid": "01EA"},
  {"id": 236, "car_id": 12, "code": "NO DATA", "pid": "01EB"},
  {"id": 237, "car_id": 12, "code": "NO DATA", "pid": "01EC"},
  {"id": 238, "car_id": 12, "code": "NO DATA", "pid": "01ED"},
  {"id": 239, "car_id": 12, "code": "NO DATA", "pid": "01EE"},
  {"id": 240, "car_id": 12, "code": "NO DATA", "pid": "01EF"},
  {"id": 241, "car_id": 12, "code": "NO DATA", "pid": "01F0"},
  {"id": 242, "car_id": 12, "code": "NO DATA", "pid": "01F1"},
  {"id": 243, "car_id": 12, "code": "NO DATA", "pid": "01F2"},
  {"id": 244, "car_id": 12, "code": "NO DATA", "pid": "01F3"},
  {"id": 245, "car_id": 12, "code": "NO DATA", "pid": "01F4"},
  {"id": 246, "car_id": 12, "code": "NO DATA", "pid": "01F5"},
  {"id": 247, "car_id": 12, "code": "NO DATA", "pid": "01F6"},
  {"id": 248, "car_id": 12, "code": "NO DATA", "pid": "01F7"},
  {"id": 249, "car_id": 12, "code": "NO DATA", "pid": "01F8"},
  {"id": 250, "car_id": 12, "code": "NO DATA", "pid": "01F9"},
  {"id": 251, "car_id": 12, "code": "NO DATA", "pid": "01FA"},
  {"id": 252, "car_id": 12, "code": "NO DATA", "pid": "01FB"},
  {"id": 253, "car_id": 12, "code": "NO DATA", "pid": "01FC"},
  {"id": 254, "car_id": 12, "code": "NO DATA", "pid": "01FD"},
  {"id": 255, "car_id": 12, "code": "NO DATA", "pid": "01FE"},
  {"id": 256, "car_id": 12, "code": "NO DATA\n", "pid": "01FF"},
];

Future<void> preloadSampleObdDataIfNeeded() async {
  final prefs = await SharedPreferences.getInstance();
  final existing = prefs.getString('last_obd_data');

  if (existing == null) {
    final Map<String, String> parsedMap = {
      for (final entry in rawObdSample)
        entry['pid'].toString().replaceFirst('01', ''):
            entry['code'].toString(),
    };

    await prefs.setString('last_obd_data', jsonEncode(parsedMap));
    print('📦 샘플 OBD 데이터 저장 완료 (${parsedMap.length}개)');
  }
}

String? extractSampleDistanceHex() {
  final entry = rawObdSample.firstWhere(
    (e) => e['pid'] == '011F',
    orElse: () => {},
  );

  if (entry.isEmpty || entry['code'] == null) return null;

  // 다중 응답 중 첫 번째 라인만 사용 (예: "7E904411F0227\n7E804411F0227")
  final code = entry['code'].toString().split('\n').first.trim();

  // 예시: "7E904411F0227" → 마지막 4자리만 사용
  final hex = code.substring(code.length - 4);
  return hex;
}

int? parseDistanceFromSample() {
  final hex = extractSampleDistanceHex();
  if (hex == null) return null;

  try {
    return int.parse(hex, radix: 16);
  } catch (e) {
    print("❌ 주행거리 파싱 실패: $e");
    return null;
  }
}

int? parseDistanceSinceDtcCleared() {
  final entry = rawObdSample.firstWhere(
    (e) => e['pid'] == '0131',
    orElse: () => {},
  );

  if (entry.isEmpty || entry['code'] == null) return null;

  final codeLine = entry['code'].toString().split('\n').first.trim();

  // 예: "7E904413135B4" → 마지막 4자리인 "35B4" (== 13748km)
  final hex = codeLine.substring(codeLine.length - 4);

  try {
    return int.parse(hex, radix: 16); // 0x35B4 = 13748
  } catch (e) {
    print("❌ DTC 삭제 후 주행거리 파싱 실패: $e");
    return null;
  }
}
