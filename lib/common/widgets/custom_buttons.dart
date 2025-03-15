import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mdiho/common/res/app_colors.dart';

class GradientIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const GradientIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              theme.brightness == Brightness.dark
                  ? AppColors.whiteColor.shade500
                  : const Color(0xFFFAFAFA),
              theme.brightness == Brightness.dark
                  ? AppColors.whiteColor.shade300
                  : Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: theme.brightness == Brightness.dark
              ? AppColors.whiteColor.shade500
              : AppColors.greyColor.shade500,
        ),
      ),
    );
  }
}

// class TradeButton extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final VoidCallback onTap;
//   final double width;
//   final Color color;
//   final Color text;

//   const TradeButton({
//     super.key,
//     required this.title,
//     this.icon = HugeIcons.strokeRoundedTradeDown,
//     required this.onTap,
//     this.width = 88,
//     this.color = const Color(0xFFF7F1F8),
//     this.text = AppColors.purple,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 44,
//         width: width,
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         decoration: BoxDecoration(
//           color: color, // Light purple color
//           borderRadius: BorderRadius.circular(12), // Rounded corners
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 color: text, // Purple color
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const Gap(8), // Space between text and icon
//             HugeIcon(
//               icon: icon,
//               size: 20,
//               color: text,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class FullButton extends StatelessWidget {
  final String text;
  final Color? color;
  final double width;
  final double height;
  final Color textColor;
  final VoidCallback onPressed;
  final VoidCallback? doublePressed;
  final double fontSize;
  final double radius;
  final bool isLoading;
  final bool isDisabled;

  const FullButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.onPressed,
    this.color,
    required this.textColor,
    this.fontSize = 16,
    this.radius = 12,
    this.isLoading = false,
    this.isDisabled = false,
    this.doublePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled || isLoading,
      child: GestureDetector(
        onTap: isDisabled || isLoading ? null : onPressed,
        onDoubleTap: doublePressed,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: isDisabled ? AppColors.greyColor.shade200 : color,
          ),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: isDisabled ? Colors.white : textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class OutlinButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color bgColor;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const OutlinButton(
      {super.key,
      required this.text,
      required this.width,
      required this.height,
      required this.onPressed,
      required this.color,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: color, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class OutlinIconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final double width;
  final double height;
  final double radius;
  final double fontSize;
  final VoidCallback onPressed;

  const OutlinIconButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.color,
    required this.bgColor,
    required this.icon,
    this.fontSize = 16,
    this.radius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: color)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: fontSize,
            ),
            const Gap(8),
            Text(
              text,
              style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class ImgButton extends StatelessWidget {
  final double fontSize;
  final String text;
  final String image;
  final Color color;
  final Color bgColor;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const ImgButton({
    super.key,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.color,
    required this.image,
    required this.bgColor,
    this.fontSize = 16,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              height: 20,
              width: 20,
              image,
            ),
            const Gap(8),
            Text(
              text,
              style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// class TextIconButton extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final Color highcolor;
//   final double? width;
//   final double? height;
//   final String text;
//   final Function()? onPressed;

//   const TextIconButton(
//       {Key? key,
//       this.width,
//       required this.icon,
//       this.onPressed,
//       this.height,
//       required this.color,
//       required this.highcolor,
//       required this.text})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         height: height,
//         width: width,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4),
//           color: highcolor,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Row(
//               children: [
//                 Icon(
//                   icon,
//                   color: color,
//                 ),
//                 const Gap(8),
//                 Text(
//                   text,
//                   style: TextStyle(
//                     color: color,
//                     fontSize: 15,
//                     fontFamily: 'Clash Grotesk Variable',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TextOutlinIconButton extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final Color highcolor;
//   final double? width;
//   final double? height;
//   final String text;
//   final Function()? onPressed;

//   const TextOutlinIconButton(
//       {Key? key,
//       this.width,
//       required this.icon,
//       this.onPressed,
//       this.height,
//       required this.color,
//       required this.highcolor,
//       required this.text})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         height: height,
//         width: width,
//         decoration: BoxDecoration(
//             color: highcolor,
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(color: color)),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Row(
//               children: [
//                 Icon(
//                   icon,
//                   color: color,
//                 ),
//                 const Gap(8),
//                 Text(
//                   text,
//                   style: TextStyle(
//                     color: color,
//                     fontSize: 16,
//                     fontFamily: 'Clash Grotesk Variable',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ImgBton extends StatelessWidget {
//   final String image;
//   final Color color;
//   final double width;
//   final double height;
//   final VoidCallback onPressed;

//   const ImgBton(
//       {super.key,
//       required this.width,
//       required this.height,
//       required this.onPressed,
//       required this.color,
//       required this.image});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         height: height,
//         width: width,
//         decoration: BoxDecoration(
//             color: AppColors.materialthemeRefPrimaryPrimary96,
//             borderRadius: BorderRadius.circular(4),
//             border: Border.all(color: color)),
//         child: Center(
//           child: Image.asset(
//             height: 24,
//             width: 24,
//             image,
//           ),
//         ),
//       ),
//     );
//   }
// }
