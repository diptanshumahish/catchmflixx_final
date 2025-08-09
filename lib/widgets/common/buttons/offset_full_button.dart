import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:flutter/material.dart';
import 'package:catchmflixx/theme/typography.dart';
import 'package:flutter/scheduler.dart';

class OffsetFullButton extends StatefulWidget {
  final String content;
  final IconData? icon;
  final VoidCallback fn;
  final bool? notFull;
  final bool? isLoading;

  const OffsetFullButton({
    super.key,
    this.isLoading = false,
    required this.content,
    required this.fn,
    this.icon,
    this.notFull,
  });

  @override
  State<OffsetFullButton> createState() => _OffsetFullButtonState();
}

class _OffsetFullButtonState extends State<OffsetFullButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool renderNotFull = widget.notFull == true;
    final double buttonWidth = renderNotFull ? size.width / 3 : size.width;
    final Color buttonColor = const Color.fromARGB(255, 255, 255, 255);
    final Color pressedColor = Color.lerp(buttonColor, Colors.black, 0.1)!;
    final Color borderColor = Color.lerp(buttonColor, Colors.white, 0.2)!;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Transform.scale(
        scale: _isPressed ? 0.98 : 1.0,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: SizedBox(
            width: buttonWidth,
            child: ElevatedButton(
              onPressed: (widget.isLoading == true)
                  ? null
                  : () async {
                      await vibrateTap();
                      widget.fn();
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                backgroundColor: _isPressed ? pressedColor : buttonColor,
                foregroundColor: Colors.black,
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: borderColor, width: 1.0),
                ),
              ).copyWith(
                overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return pressedColor.withOpacity(0.9);
                  }
                  return null;
                }),
              ),
              child: widget.isLoading == true
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.6),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null)
                          Icon(
                            widget.icon,
                            color: Colors.black,
                            size: 20,
                          ),
                        if (widget.icon != null) const SizedBox(width: 8),
                        Flexible(
                          child: AppText(
                            widget.content,
                            variant: AppTextVariant.subtitle,
                            color: Colors.black,
                            weight: FontWeight.w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
