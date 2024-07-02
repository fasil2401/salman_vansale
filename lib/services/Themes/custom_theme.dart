import 'package:axoproject/services/Themes/app_theme.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
    required this.data,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final String initialThemeKey;

  const CustomTheme({
    Key? key,
    required this.initialThemeKey,
    required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => new CustomThemeState();

  static ThemeData of(BuildContext context) {
    _CustomTheme inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>()!);
    return inherited.data.theme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    _CustomTheme inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>()!);
    return inherited.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  late ThemeData _theme;

  ThemeData get theme => _theme;

  @override
  void initState() {
    _theme = MyThemes.getThemeFromKey(widget.initialThemeKey);
    super.initState();
  }

  void changeTheme(String themeKey) async {
    setState(() {
      _theme = MyThemes.getThemeFromKey(themeKey);
    });
    await UserSimplePreferences.setTheme(themeKey);
  }

  @override
  Widget build(BuildContext context) {
    return _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}
