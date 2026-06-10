// Switched to CustomPaint icons by https://github.com/esDotDev

import 'package:flutter/widgets.dart';

/// Close
class CloseIcon extends _PaintIcon {
  CloseIcon({super.key, required Color color})
      : super(
          size: const Size.square(10),
          painter: _CloseIconPainter(color),
        );
}

class _CloseIconPainter extends _IconPainter {
  _CloseIconPainter(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), p);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), p);
  }
}

/// Maximize
class MaximizeIcon extends _PaintIcon {
  MaximizeIcon({super.key, required Color color})
      : super(
          size: const Size.square(9),
          painter: _MaximizePainter(color),
        );
}

class _MaximizePainter extends _IconPainter {
  _MaximizePainter(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), p);
  }
}

/// Restore
class RestoreIcon extends _PaintIcon {
  RestoreIcon({super.key, required Color color})
      : super(
          size: const Size.square(10),
          painter: _RestorePainter(color),
        );
}

class _RestorePainter extends _IconPainter {
  _RestorePainter(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    // 线条之间形成的直角有一个0.5像素的间距
    const angleOffset = 0.25;
    const gap = 2.0;

    canvas.drawRect(Rect.fromLTRB(0, gap, size.width - gap, size.height), p);
    // left
    canvas.drawLine(const Offset(gap, 0), const Offset(gap, gap), p);
    // top
    canvas.drawLine(const Offset(gap - angleOffset, 0),
        Offset(size.width + angleOffset * 2, 0), p);
    // right
    canvas.drawLine(Offset(size.width, 0),
        Offset(size.width, size.height - gap + angleOffset), p);
    // bottom
    canvas.drawLine(Offset(size.width - gap, size.height - gap),
        Offset(size.width, size.height - gap), p);
  }
}

/// Minimize
class MinimizeIcon extends _PaintIcon {
  MinimizeIcon({super.key, required Color color})
      : super(
          size: const Size(10, 1),
          painter: _MinimizeIconPainter(color),
        );
}

class _MinimizeIconPainter extends _IconPainter {
  _MinimizeIconPainter(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), p);
  }
}

/// Helpers
abstract class _IconPainter extends CustomPainter {
  _IconPainter(this.color)
      : p = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..isAntiAlias = false
          ..strokeWidth = 1;

  final Color color;
  final Paint p;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      color != (oldDelegate as _IconPainter).color;
}

class _PaintIcon extends StatelessWidget {
  const _PaintIcon({
    super.key,
    required this.size,
    required this.painter,
  });

  final Size size;
  final _IconPainter painter;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CustomPaint(size: size, painter: painter),
    );
  }
}
