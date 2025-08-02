import 'package:flutter/material.dart';
import '../tokens.dart';

enum RadixButtonVariant {
  solid,
  soft,
  outline,
  ghost,
}

enum RadixButtonSize {
  small,
  medium,
  large,
}

class RadixButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final RadixButtonVariant variant;
  final RadixButtonSize size;
  final Widget? icon;
  final bool loading;
  final bool fullWidth;

  const RadixButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = RadixButtonVariant.solid,
    this.size = RadixButtonSize.medium,
    this.icon,
    this.loading = false,
    this.fullWidth = false,
  });

  @override
  State<RadixButton> createState() => _RadixButtonState();
}

class _RadixButtonState extends State<RadixButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.loading;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: isEnabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: widget.fullWidth ? double.infinity : null,
          height: _getHeight(),
          padding: _getPadding(),
          decoration: BoxDecoration(
            color: _getBackgroundColor(isEnabled),
            border: Border.all(
              color: _getBorderColor(isEnabled),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(RadixTokens.radius3),
            boxShadow: _isPressed && isEnabled ? [] : [
              if (widget.variant == RadixButtonVariant.solid && isEnabled)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.loading)
                SizedBox(
                  width: _getIconSize(),
                  height: _getIconSize(),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _getTextColor(isEnabled),
                  ),
                )
              else if (widget.icon != null) ...[
                SizedBox(
                  width: _getIconSize(),
                  height: _getIconSize(),
                  child: widget.icon,
                ),
                const SizedBox(width: RadixTokens.space2),
              ],
              Text(
                widget.text,
                style: _getTextStyle(isEnabled),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getHeight() {
    switch (widget.size) {
      case RadixButtonSize.small:
        return 32;
      case RadixButtonSize.medium:
        return 36;
      case RadixButtonSize.large:
        return 40;
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case RadixButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: RadixTokens.space3,
          vertical: RadixTokens.space1,
        );
      case RadixButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: RadixTokens.space4,
          vertical: RadixTokens.space2,
        );
      case RadixButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: RadixTokens.space5,
          vertical: RadixTokens.space3,
        );
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case RadixButtonSize.small:
        return 14;
      case RadixButtonSize.medium:
        return 16;
      case RadixButtonSize.large:
        return 18;
    }
  }

  Color _getBackgroundColor(bool isEnabled) {
    if (!isEnabled) {
      return RadixTokens.slate3;
    }

    switch (widget.variant) {
      case RadixButtonVariant.solid:
        if (_isPressed) return RadixTokens.indigo10;
        if (_isHovered) return RadixTokens.indigo10;
        return RadixTokens.indigo9;
      
      case RadixButtonVariant.soft:
        if (_isPressed) return RadixTokens.indigo4;
        if (_isHovered) return RadixTokens.indigo4;
        return RadixTokens.indigo3;
      
      case RadixButtonVariant.outline:
        if (_isPressed) return RadixTokens.indigo3;
        if (_isHovered) return RadixTokens.indigo2;
        return Colors.transparent;
      
      case RadixButtonVariant.ghost:
        if (_isPressed) return RadixTokens.indigo3;
        if (_isHovered) return RadixTokens.indigo2;
        return Colors.transparent;
    }
  }

  Color _getBorderColor(bool isEnabled) {
    if (!isEnabled) {
      return RadixTokens.slate6;
    }

    switch (widget.variant) {
      case RadixButtonVariant.solid:
        return RadixTokens.indigo9;
      case RadixButtonVariant.soft:
        return Colors.transparent;
      case RadixButtonVariant.outline:
        return RadixTokens.slate7;
      case RadixButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _getTextColor(bool isEnabled) {
    if (!isEnabled) {
      return RadixTokens.slate8;
    }

    switch (widget.variant) {
      case RadixButtonVariant.solid:
        return Colors.white;
      case RadixButtonVariant.soft:
      case RadixButtonVariant.outline:
      case RadixButtonVariant.ghost:
        return RadixTokens.indigo11;
    }
  }

  TextStyle _getTextStyle(bool isEnabled) {
    final baseStyle = widget.size == RadixButtonSize.small
        ? RadixTokens.caption
        : RadixTokens.body2;

    return baseStyle.copyWith(
      color: _getTextColor(isEnabled),
      fontWeight: FontWeight.w500,
    );
  }
}