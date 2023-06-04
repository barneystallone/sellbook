import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/login_form.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? status = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('😍'),
            content: Row(
              children: const <Widget>[
                Expanded(
                  child: Text(
                    'Bạn có muốn thoát khỏi ứng dụng?',
                    style: TextStyle(fontSize: 22.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        if (status == null || !status) return false;

        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return true;
      },
      child: const Scaffold(
        body: LoginForm(),
      ),
    );
  }
}
