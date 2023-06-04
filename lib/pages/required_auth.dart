import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../pages/auth.dart';
import '../pages/home_page.dart';

import '../services/local/shared_prefs.dart';

class RequiredAuth extends StatefulWidget {
  const RequiredAuth({super.key});

  @override
  State<RequiredAuth> createState() => _RequiredAuthState();
}

class _RequiredAuthState extends State<RequiredAuth> {
  final SharedPrefs _prefs = SharedPrefs();
  Future<Widget> checkLogin() async {
    UserModel? user = await _prefs.getCurrentUser();
    print(user);
    await Future.delayed(const Duration(milliseconds: 1200));
    return (user != null) ? HomePage(user: user) : const Auth();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Hiển thị màn hình chờ khi đang kiểm tra đăng nhập
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.cyanAccent,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // Xử lý lỗi nếu có
          return Scaffold(
            body: Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            ),
          );
        } else {
          // Trả về widget tương ứng sau khi kiểm tra đăng nhập hoàn tất
          return snapshot.data ?? Container();
        }
      },
    );
  }
}
