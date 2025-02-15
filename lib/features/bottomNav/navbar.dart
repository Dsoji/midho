import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../common/res/app_colors.dart';
import '../home/presentation/home_screen.dart';
import 'bottom_nav.dart';

class NaviBar extends StatefulWidget {
  final int? index;
  const NaviBar({
    super.key,
    this.index = 0,
  });

  @override
  State<NaviBar> createState() => _NaviBarState();
}

class _NaviBarState extends State<NaviBar> {
  List<Widget> pageList = [
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
  ];

  late int pageIndex;

  @override
  void initState() {
    super.initState();
    // requestStoragePermission();
    pageIndex = widget.index!;
  }

  void changePage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  // void requestStoragePermission() async {
  //   // Check if the platform is not web, as web has no permissions
  //   if (!kIsWeb) {
  //     // Request storage permission
  //     var status = await Permission.storage.status;
  //     if (!status.isGranted) {
  //       await Permission.storage.request();
  //     }

  //     // Request camera permission
  //     var cameraStatus = await Permission.camera.status;
  //     if (!cameraStatus.isGranted) {
  //       await Permission.camera.request();
  //     }
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      body: pageList[pageIndex],
      bottomNavigationBar: Container(
        height: 85,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade600
              : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomNav(
              index: 0,
              onTap: () {
                changePage(0);
              },
              icon: pageIndex == 0
                  ? IconsaxPlusBold.home_2
                  : IconsaxPlusLinear.home_2,
              label: 'Home',
              color: pageIndex == 0
                  ? AppColors.primaryColor.shade500
                  : AppColors.secondaryColor.shade200,
            ),
            BottomNav(
              index: 1,
              onTap: () {
                changePage(1);
              },
              icon: pageIndex == 1
                  ? IconsaxPlusBold.gift
                  : IconsaxPlusLinear.gift,
              label: 'Menu',
              color: pageIndex == 1
                  ? AppColors.primaryColor.shade500
                  : AppColors.secondaryColor.shade200,
            ),
            BottomNav(
              index: 2,
              onTap: () {
                changePage(2);
              },
              icon: pageIndex == 2
                  ? IconsaxPlusBold.coin
                  : IconsaxPlusLinear.coin,
              label: 'Wallet',
              color: pageIndex == 2
                  ? AppColors.primaryColor.shade500
                  : AppColors.secondaryColor.shade200,
            ),
            BottomNav(
              index: 3,
              onTap: () {
                changePage(3);
              },
              icon: pageIndex == 3
                  ? IconsaxPlusBold.arrow_swap
                  : IconsaxPlusLinear.arrow_swap,
              label: 'Stats',
              color: pageIndex == 3
                  ? AppColors.primaryColor.shade500
                  : AppColors.secondaryColor.shade200,
            ),
            BottomNav(
              index: 4,
              onTap: () {
                changePage(4);
              },
              icon: pageIndex == 4
                  ? IconsaxPlusBold.user
                  : IconsaxPlusLinear.user,
              label: 'Profile',
              color: pageIndex == 4
                  ? AppColors.primaryColor.shade500
                  : AppColors.secondaryColor.shade200,
            ),
          ],
        ),
      ),
    );
  }
}
