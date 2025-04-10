import 'package:flutter/material.dart';
import 'package:marimo_client/screens/signin/SignUpScreen.dart';

class LoginLinkRow extends StatelessWidget {
  final VoidCallback? onFindPassword;

  const LoginLinkRow({super.key, this.onFindPassword});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onFindPassword,
          child: const Text(
            "",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // const 제거: Provider가 올바르게 생성되도록 함
            Navigator.of(context).push(_slideRoute(SignUpScreen()));
          },
          child: const Text(
            "회원가입",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  Route _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
