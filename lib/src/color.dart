import 'dart:ui';

class WindowButtonColor {
  const WindowButtonColor({
    required this.normal,
    required this.mouseOver,
    required this.mouseDown,
    required this.iconNormal,
    required this.iconMouseOver,
    required this.iconMouseDown,
  });

  const WindowButtonColor.light({
    this.normal = const Color.fromARGB(0, 0, 0, 0),
    this.mouseOver = const Color.fromARGB(20, 0, 0, 0),
    this.mouseDown = const Color.fromARGB(40, 0, 0, 0),
    this.iconNormal = const Color(0xe4000000),
    this.iconMouseOver = const Color(0xe4000000),
    this.iconMouseDown = const Color(0x9b000000),
  });

  const WindowButtonColor.dark({
    this.normal = const Color.fromARGB(0, 255, 255, 255),
    this.mouseOver = const Color.fromARGB(25, 255, 255, 255),
    this.mouseDown = const Color.fromARGB(35, 255, 255, 255),
    this.iconNormal = const Color(0xFFFFFFFF),
    this.iconMouseOver = const Color(0xc8ffffff),
    this.iconMouseDown = const Color.fromRGBO(255, 255, 255, 0.365),
  });

  const WindowButtonColor.closeLight({
    this.normal = const Color.fromARGB(0, 232, 17, 35),
    this.mouseOver = const Color(0xFFE81123),
    this.mouseDown = const Color.fromRGBO(154, 28, 41, 1),
    this.iconNormal = const Color(0xe4000000),
    this.iconMouseOver = const Color(0xFFFFFFFF),
    this.iconMouseDown = const Color(0xFFFFFFFF),
  });

  const WindowButtonColor.closeDark({
    this.normal = const Color.fromARGB(0, 232, 17, 35),
    this.mouseOver = const Color(0xFFE81123),
    this.mouseDown = const Color.fromRGBO(154, 28, 41, 1),
    this.iconNormal = const Color(0xFFFFFFFF),
    this.iconMouseOver = const Color(0xFFFFFFFF),
    this.iconMouseDown = const Color(0xFFFFFFFF),
  });

  final Color normal;
  final Color mouseOver;
  final Color mouseDown;
  final Color iconNormal;
  final Color iconMouseOver;
  final Color iconMouseDown;
}
