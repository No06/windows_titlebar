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
        buttonColor = null;

  const WindowTitleBarButton.close({
    super.key,
    this.onTap,
    this.color = const Color(0x00000000),
    this.buttonColor = const WindowButtonColor.closeLight(),
    this.animated = false,
  })  : _type = _ButtonType.close,
        icon = null;

  const WindowTitleBarButton.unmaximize({
    super.key,
    this.onTap,
    this.color = const Color(0x00000000),
    this.buttonColor = const WindowButtonColor.light(),
    this.animated = false,
  })  : _type = _ButtonType.unmaximize,
        icon = null;

  const WindowTitleBarButton.maximize({
    super.key,
    this.onTap,
    this.color = const Color(0x00000000),
    this.buttonColor = const WindowButtonColor.light(),
    this.animated = false,
  })  : _type = _ButtonType.maximize,
        icon = null;

  const WindowTitleBarButton.minimize({
    super.key,
    this.onTap,
    this.color = const Color(0x00000000),
    this.buttonColor = const WindowButtonColor.light(),
    this.animated = false,
  })  : _type = _ButtonType.minimize,
        icon = null;

  final Widget? icon;
  final VoidCallback? onTap;
  final Color? color;
  final WindowButtonColor? buttonColor;
  final bool animated;
  final _ButtonType? _type;

  static const animatedTime = 120;

  @override
  State<WindowTitleBarButton> createState() => _WindowTitleBarButtonState();
}

class _WindowTitleBarButtonState extends State<WindowTitleBarButton> {
  Color get _backgroundColor {
    if (state.onTap) return widget.buttonColor!.mouseDown;
    if (state.isHover) return widget.buttonColor!.mouseOver;
    return widget.buttonColor!.normal;
  }

  Color get _iconColor {
    if (state.onTap) return widget.buttonColor!.iconMouseDown;
    if (state.isHover) return widget.buttonColor!.iconMouseOver;
    return widget.buttonColor!.iconNormal;
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
