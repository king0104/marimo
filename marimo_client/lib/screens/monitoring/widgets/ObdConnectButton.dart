import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:provider/provider.dart';

class ObdConnectButton extends StatefulWidget {
  const ObdConnectButton({super.key});

  @override
  State<ObdConnectButton> createState() => _ObdConnectButtonState();
}

class _ObdConnectButtonState extends State<ObdConnectButton> {
  bool isConnecting = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ObdPollingProvider>(context);
    final isConnected = provider.isConnected;

    return GestureDetector(
      onTap: () async {
        if (isConnected || isConnecting) return;

        setState(() => isConnecting = true);
        await provider.connectAndStartPolling(context); // context 넘겨줌
        setState(() => isConnecting = false);
      },
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9DBFFF), Color(0xFF4888FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child:
              isConnecting || isConnected
                  ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Image.asset(
                    'assets/images/icons/connect.png',
                    width: 28.sp,
                    color: Colors.white,
                  ),
        ),
      ),
    );
  }
}
