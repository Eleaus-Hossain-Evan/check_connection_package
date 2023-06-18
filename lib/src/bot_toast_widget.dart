import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

showAttachedWidget({
  UniqueKey? key,
  required Widget Function(void Function()) builder,
}) =>
    BotToast.showAnimationWidget(
      key: key,
      toastBuilder: builder,
      clickClose: true,
      allowClick: true,
      onlyOne: false,
      crossPage: false,
      backButtonBehavior: BackButtonBehavior.ignore,
      wrapToastAnimation: (controller, cancel, Widget child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              cancel();
            },
            child: AnimatedBuilder(
              builder: (_, child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              animation: controller,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
            ),
          ),
          CustomOffsetAnimation(controller: controller, child: child)
        ],
      ),
      animationDuration: const Duration(milliseconds: 300),
      // duration: const Duration(seconds: 2),
    );

class CustomOffsetAnimation extends HookConsumerWidget {
  final AnimationController controller;
  final Widget child;

  const CustomOffsetAnimation(
      {Key? key, required this.controller, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final tweenOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.8),
      end: Offset.zero,
    );
    final tweenScale = Tween<double>(begin: 0.3, end: 1.0);
    final animation =
        CurvedAnimation(parent: controller, curve: Curves.decelerate);
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return FractionalTranslation(
          translation: tweenOffset.evaluate(animation),
          child: ClipRect(
            child: Transform.scale(
              scale: tweenScale.evaluate(animation),
              child: Opacity(
                opacity: animation.value,
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}
