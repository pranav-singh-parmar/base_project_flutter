import 'package:flutter/material.dart';

import '../../constants_and_extenstions/theme_controller.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool? centerTitle;

  const CustomAppBar({Key? key, this.title, this.centerTitle = true})
      : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final _themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: widget.centerTitle,
      title: Text(
        widget.title ?? "",
        style: _themeController.bitterFont(
          fontSize: FontSize.headline,
        ),
      ),
    );
  }
}
