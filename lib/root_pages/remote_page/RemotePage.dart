import 'package:flutter/material.dart';

class RemotePage extends StatelessWidget {
  final dynamic onPlayPressed;
  final dynamic onPausePressed;
  final dynamic onNextPressed;
  final dynamic onPrevPressed;
  final bool useDesktopLayout;

  const RemotePage({
    Key? key,
    this.onNextPressed,
    this.onPausePressed,
    this.onPlayPressed,
    this.onPrevPressed,
    this.useDesktopLayout = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (useDesktopLayout) {
      const double buttonSize = 28;

      return _DesktopLayout(
          play: _Button(
            size: buttonSize,
            icon: const Icon(Icons.play_circle),
            onPressed: () => onPlayPressed?.call(),
          ),
          pause: _Button(
            size: buttonSize,
            icon: const Icon(Icons.pause_circle),
            onPressed: () => onPausePressed?.call(),
          ),
          next: _Button(
              size: buttonSize,
              icon: const Icon(Icons.fast_forward),
              onPressed: () => onNextPressed?.call()),
          prev: _Button(
            size: buttonSize,
            icon: const Icon(Icons.fast_rewind),
            onPressed: () => onPrevPressed?.call(),
          ));
    }

    return _MobileLayout(
        play: _Button(
          icon: const Icon(Icons.play_circle),
          onPressed: () => onPlayPressed?.call(),
        ),
        pause: _Button(
          icon: const Icon(Icons.pause_circle),
          onPressed: () => onPausePressed?.call(),
        ),
        next: _Button(
            icon: const Icon(Icons.fast_forward),
            onPressed: () => onNextPressed?.call()),
        prev: _Button(
          icon: const Icon(Icons.fast_rewind),
          onPressed: () => onPrevPressed?.call(),
        ));
  }
}

class _MobileLayout extends StatelessWidget {
  final Widget play;
  final Widget pause;
  final Widget next;
  final Widget prev;

  const _MobileLayout(
      {Key? key,
      required this.play,
      required this.pause,
      required this.next,
      required this.prev})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Spacer(
            flex: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [play],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [prev, next],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [pause],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final Widget play;
  final Widget pause;
  final Widget next;
  final Widget prev;

  const _DesktopLayout(
      {Key? key,
      required this.play,
      required this.pause,
      required this.next,
      required this.prev})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(width: 16);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [prev, spacer, pause, spacer, play, spacer, next],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final double size;
  final Icon icon;
  final dynamic onPressed;

  const _Button({Key? key, required this.icon, this.onPressed, this.size = 72})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: size,
      splashRadius: size,
      icon: icon,
      onPressed: () => onPressed?.call(),
    );
  }
}
