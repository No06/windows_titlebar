import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_titlebar/src/color.dart';
import 'package:windows_titlebar/src/icons.dart';

const kWindowTitleBarHeight = kWindowCaptionHeight;

class WindowTitleBarButton extends StatefulWidget {
  const WindowTitleBarButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color = const Color(0x00000000),
    this.animated = false,
  })  : _type = null,
        brightness = null,
        iconColor = null,
        darkIconColor = null;

  const WindowTitleBarButton.close({
    super.key,
    this.brightness = Brightness.light,
    this.onTap,
    this.color = const Color(0x00000000),
    this.iconColor = const WindowTitleBarButtonColor.closeLight(),
    this.darkIconColor = const WindowTitleBarButtonColor.closeDark(),
    this.animated = false,
  })  : _type = _ButtonType.close,
        icon = null;

  const WindowTitleBarButton.unmaximize({
    super.key,
    this.brightness = Brightness.light,
    this.onTap,
    this.color = const Color(0x00000000),
    this.iconColor = const WindowTitleBarButtonColor.light(),
    this.darkIconColor = const WindowTitleBarButtonColor.dark(),
    this.animated = false,
  })  : _type = _ButtonType.unmaximize,
        icon = null;

  const WindowTitleBarButton.maximize({
    super.key,
    this.brightness = Brightness.light,
    this.onTap,
    this.color = const Color(0x00000000),
    this.iconColor = const WindowTitleBarButtonColor.light(),
    this.darkIconColor = const WindowTitleBarButtonColor.dark(),
    this.animated = false,
  })  : _type = _ButtonType.maximize,
        icon = null;

  const WindowTitleBarButton.minimize({
    super.key,
    this.brightness = Brightness.light,
    this.onTap,
    this.color = const Color(0x00000000),
    this.iconColor = const WindowTitleBarButtonColor.light(),
    this.darkIconColor = const WindowTitleBarButtonColor.dark(),
    this.animated = false,
  })  : _type = _ButtonType.minimize,
        icon = null;

  final Brightness? brightness;
  final Widget? icon;
  final VoidCallback? onTap;
  final Color? color;
  final WindowTitleBarButtonColor? iconColor;
  final WindowTitleBarButtonColor? darkIconColor;
  final bool animated;
  final _ButtonType? _type;

  static const animatedTime = 120;

  @override
  State<WindowTitleBarButton> createState() => _WindowTitleBarButtonState();
}

class _WindowTitleBarButtonState extends State<WindowTitleBarButton> {
  WindowTitleBarButtonColor get _color {
    switch (widget.brightness!) {
      case Brightness.dark:
        return widget.darkIconColor!;
      case Brightness.light:
        return widget.iconColor!;
    }
  }

  Color get _backgroundColor {
    if (state.onTap) return _color.mouseDown;
    if (state.isHover) return _color.mouseOver;
    return _color.normal;
  }

  Color get _iconColor {
    if (state.onTap) return _color.iconMouseDown;
    if (state.isHover) return _color.iconMouseOver;
    return _color.iconNormal;
  }

  Widget get _icon {
    switch (widget._type!) {
      case _ButtonType.close:
        return CloseIcon(color: _iconColor);
      case _ButtonType.unmaximize:
        return RestoreIcon(color: _iconColor);
      case _ButtonType.maximize:
        return MaximizeIcon(color: _iconColor);
      case _ButtonType.minimize:
        return MinimizeIcon(color: _iconColor);
    }
  }

  Duration get _duration => widget.animated
      ? const Duration(milliseconds: WindowTitleBarButton.animatedTime)
      : Duration.zero;

  final state = _ButtonState();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (value) => state.isHover = false,
      onHover: (value) => state.isHover = true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => state.onTap = true,
        onTapCancel: () => state.onTap = false,
        onTapUp: (_) => state.onTap = false,
        onTap: widget.onTap,
        child: ListenableBuilder(
          listenable: state,
          builder: (context, child) => AnimatedContainer(
            duration: _duration,
            curve: Curves.linear,
            color: _backgroundColor,
            constraints: const BoxConstraints(minWidth: 46, minHeight: 32),
            child: Center(child: widget.icon ?? _icon),
          ),
        ),
      ),
    );
  }
}

class _ButtonState with ChangeNotifier {
  var _isHover = false;
  bool get isHover => _isHover;
  set isHover(bool newVal) {
    _isHover = newVal;
    notifyListeners();
  }

  var _onTap = false;
  bool get onTap => _onTap;
  set onTap(bool newVal) {
    _onTap = newVal;
    notifyListeners();
  }
}

enum _ButtonType {
  close,
  unmaximize,
  maximize,
  minimize,
}
