import 'package:flutter/material.dart';

class RemotePage extends StatelessWidget {
  final dynamic onPlayPressed;
  final dynamic onPausePressed;
  final dynamic onNextPressed;
  final dynamic onPrevPressed;

  const RemotePage(
      {Key? key,
      this.onNextPressed,
      this.onPausePressed,
      this.onPlayPressed,
      this.onPrevPressed})
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
            children: [
              _Button(
                icon: const Icon(Icons.play_circle),
                onPressed: () => onPlayPressed?.call(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Button(
                icon: const Icon(Icons.fast_rewind),
                onPressed: () => onPrevPressed?.call(),
              ),
              _Button(
                  icon: const Icon(Icons.fast_forward),
                  onPressed: () => onNextPressed?.call()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Button(
                icon: const Icon(Icons.pause_circle),
                onPressed: () => onPausePressed?.call(),
              ),
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Icon icon;
  final dynamic onPressed;

  const _Button({Key? key, required this.icon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 72,
      icon: icon,
      onPressed: () => onPressed?.call(),
    );
  }
}
