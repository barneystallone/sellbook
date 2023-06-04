import 'package:flutter/material.dart';
import '../pages/required_auth.dart';
import '../resources/app_color.dart';
import '../services/local/shared_prefs.dart';

class TdAppBar extends StatelessWidget implements PreferredSizeWidget {
  TdAppBar({
    super.key,
    this.rightPressed,
    this.overlay,
    required this.title,
    this.color = AppColor.bgColor,
  });
  final SharedPrefs _prefs = SharedPrefs();
  final VoidCallback? rightPressed;
  final Widget? overlay;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
              top: MediaQuery.of(context).padding.top + 4.6, bottom: 8.0),
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/sach1.jpg'),
                radius: 24.0,
              ),
              Text(title,
                  style: const TextStyle(color: AppColor.blue, fontSize: 22.0)),
              PopupMenuButton(
                icon: const Icon(Icons.menu),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      value: 0,
                      height: 30,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.logout,
                            size: 16.0,
                            color: AppColor.brown,
                          ),
                          SizedBox(width: 12.0),
                          Expanded(child: Text('Logout')),
                        ],
                      )),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      _prefs.logOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RequiredAuth()));
                      break;
                  }
                },
              )
            ],
          ),
        ),
        if (overlay != null) overlay!
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}
