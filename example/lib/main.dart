import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_titlebar/windows_titlebar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  const windowSize = Size(500, 200);
  final windowOptions = WindowOptions(
    size: windowSize,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle:
        Platform.isWindows ? TitleBarStyle.hidden : TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _themeMode = ThemeMode.light;

  void _toggleThemeMode() => setState(() {
        _themeMode = switch (_themeMode) {
          ThemeMode.light => ThemeMode.dark,
          ThemeMode.dark => ThemeMode.light,
          ThemeMode.system => ThemeMode.system,
        };
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kWindowCaptionHeight),
          child: _WindowTitleBar(),
        ),
        body: Center(
          child: TextButton(
            onPressed: _toggleThemeMode,
            child: const Text("Switch Theme"),
          ),
        ),
      ),
    );
  }
}

class _WindowTitleBar extends StatefulWidget {
  const _WindowTitleBar();

  @override
  State<_WindowTitleBar> createState() => _WindowTitleBarState();
}

class _WindowTitleBarState extends State<_WindowTitleBar> with WindowListener {
  late final ValueNotifier<FutureOr<bool>> isMaximized;

  @override
  void initState() {
    super.initState();
    isMaximized = ValueNotifier(windowManager.isMaximized());
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    isMaximized.dispose();
    super.dispose();
  }

  @override
  void onWindowMaximize() => isMaximized.value = true;

  @override
  void onWindowUnmaximize() => isMaximized.value = false;

  @override
  Widget build(BuildContext context) {
    final windowButtonColor = switch (Theme.of(context).brightness) {
      Brightness.dark => const WindowButtonColor.dark(),
      Brightness.light => const WindowButtonColor.light(),
    };

    final closeWindowButtonColor = switch (Theme.of(context).brightness) {
      Brightness.dark => const WindowButtonColor.closeDark(),
      Brightness.light => const WindowButtonColor.closeLight(),
    };

    return WindowTitleBar(
      title: const DragToMoveArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text("Window Title"),
          ),
        ),
      ),
      actions: [
        // Custom Button
        WindowButton(
          animated: true,
          buttonColor: const WindowButtonColor(
            normal: Colors.blue,
            mouseOver: Colors.green,
            mouseDown: Colors.amber,
            iconNormal: Colors.white,
            iconMouseOver: Colors.grey,
            iconMouseDown: Colors.blueGrey,
          ),
          builder: (context, color) => Icon(Icons.settings, color: color),
        ),
        WindowButton.minimize(
          buttonColor: windowButtonColor,
          onTap: windowManager.minimize,
        ),
        ValueListenableBuilder(
          valueListenable: isMaximized,
          builder: (context, isMaximized, child) {
            Widget builder(bool isMaximized) {
              if (isMaximized) {
                return WindowButton.unmaximize(
                  buttonColor: windowButtonColor,
                  onTap: windowManager.unmaximize,
                );
              }
              return WindowButton.maximize(
                buttonColor: windowButtonColor,
                onTap: windowManager.maximize,
              );
            }

            if (isMaximized is Future<bool>) {
              return FutureBuilder(
                future: isMaximized,
                builder: (context, snapshot) {
                  final isMaximized = snapshot.data ?? false;
                  return builder(isMaximized);
                },
              );
            }
            return builder(isMaximized);
          },
        ),
        WindowButton.close(
          buttonColor: closeWindowButtonColor,
          onTap: windowManager.close,
        ),
      ],
    );
  }
}
