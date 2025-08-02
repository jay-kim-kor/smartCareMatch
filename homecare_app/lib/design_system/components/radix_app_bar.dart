import 'package:flutter/material.dart';
import '../tokens.dart';

class RadixAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const RadixAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: RadixTokens.slate1,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: leading ?? (showBackButton
          ? IconButton(
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: RadixTokens.slate11,
                size: 20,
              ),
            )
          : null),
      title: Text(
        title,
        style: RadixTokens.heading3.copyWith(
          color: RadixTokens.slate12,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: RadixTokens.slate6,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}