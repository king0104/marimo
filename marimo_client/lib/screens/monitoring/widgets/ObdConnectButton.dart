// TODO: 컴포넌트 삭제

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:marimo_client/providers/obd_polling_provider.dart';
// import 'package:marimo_client/utils/loading_overlay.dart';
// import 'package:marimo_client/utils/toast.dart';
// import 'package:provider/provider.dart';

// class ObdConnectButton extends StatefulWidget {
//   const ObdConnectButton({super.key});

//   @override
//   State<ObdConnectButton> createState() => _ObdConnectButtonState();
// }

// class _ObdConnectButtonState extends State<ObdConnectButton> {
//   bool isConnecting = false;

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ObdPollingProvider>(context);
//     final isConnected = provider.isConnected;

//     return GestureDetector(
//       onTap: () async {
//         if (isConnected || isConnecting) return;

//         setState(() => isConnecting = true);

//         /// ✅ 현재 context 대신 최상위 context를 가져옵니다.
//         final overlayContext = context;
//         final scaffoldMessenger = ScaffoldMessenger.of(context);

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           showLoadingOverlay(overlayContext, message: 'OBD-II에 연결 중...');
//         });

//         try {
//           await provider.connectAndStartPolling();

//           if (provider.isConnected) {
//             scaffoldMessenger.showSnackBar(
//               SnackBar(
//                 content: const Text('✅ OBD-II 연결 성공'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           } else {
//             scaffoldMessenger.showSnackBar(
//               SnackBar(
//                 content: const Text('❌ OBD 연결에 실패했습니다'),
//                 backgroundColor: Colors.redAccent,
//               ),
//             );
//           }
//         } catch (e) {
//           scaffoldMessenger.showSnackBar(
//             SnackBar(
//               content: const Text('❌ OBD 연결에 실패했습니다'),
//               backgroundColor: Colors.redAccent,
//             ),
//           );
//           debugPrint('❌ 연결 에러: $e');
//         } finally {
//           hideLoadingOverlay();
//           setState(() => isConnecting = false);
//         }
//       },
//       child: Container(
//         width: 56.w,
//         height: 56.w,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors:
//                 isConnected
//                     ? [Colors.greenAccent, Colors.green]
//                     : [const Color(0xFF9DBFFF), const Color(0xFF4888FF)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Center(
//           child:
//               isConnecting
//                   ? SizedBox(
//                     width: 24.w,
//                     height: 24.w,
//                     child: const CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                   : Image.asset(
//                     isConnected
//                         ? 'assets/images/icons/check.png'
//                         : 'assets/images/icons/connect.png',
//                     width: 28.sp,
//                     color: Colors.white,
//                   ),
//         ),
//       ),
//     );
//   }
// }
