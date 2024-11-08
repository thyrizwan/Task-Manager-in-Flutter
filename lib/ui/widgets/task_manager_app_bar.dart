import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth.dart';
import 'package:task_manager/ui/screens/profile_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TaskManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({
    super.key,
    this.isProfileScreenOpened = false,
  });

  final bool isProfileScreenOpened;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileScreenOpened) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userData?.fullName ?? 'Not Set',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AuthController.userData?.email ?? 'Not Set',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await AuthController.removeAccessToken();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                    (predicate) => false);
              },
              icon: const Icon(Icons.exit_to_app),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
