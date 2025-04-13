import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marimo_client/screens/signin/SignInScreen.dart';
import 'package:marimo_client/theme.dart';
import 'package:provider/provider.dart';
import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';

class MyPageHeader extends StatelessWidget {
  const MyPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final carProvider = context.watch<CarProvider>();
    final authProvider = context.watch<AuthProvider>();

    final carNickname =
        carProvider.cars.isNotEmpty
            ? carProvider.cars.first.nickname ?? '차량 없음'
            : '차량 없음';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '마이 페이지',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  carNickname,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.only(left: 0.w, top: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '오너 ${authProvider.userName ?? '사용자'}',
                    style: TextStyle(fontSize: 16.sp, color: brandColor),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: TextButton(
                onPressed: () async {
                  final storage = FlutterSecureStorage();
                  await storage.delete(key: 'accessToken'); // ✅ 토큰 삭제
                  print('🧹 accessToken 삭제 완료!');

                  // 앱 내 상태도 초기화해주면 좋아
                  authProvider.logout();

                  // 로그인 화면으로 이동 (선택)
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (route) => false,
                  );
                },

                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                    horizontal: 20.w,
                  ),
                  minimumSize: Size(50.w, 20.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.black.withOpacity(0.2),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 12.sp, color: iconColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
