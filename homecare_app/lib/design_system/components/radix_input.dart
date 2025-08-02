import 'package:flutter/material.dart';
import '../tokens.dart';

enum RadixInputSize {
  small,
  medium,
  large,
}

class RadixInput extends StatefulWidget {
  final String? placeholder;
  final String? value;
  final ValueChanged<String>? onChanged;
  final RadixInputSize size;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool disabled;
  final bool error;
  final String? errorText;
  final String? helperText;
  final TextInputType keyboardType;
  final bool obscureText;

  const RadixInput({
    super.key,
    this.placeholder,
    this.value,
    this.onChanged,
    this.size = RadixInputSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.disabled = false,
    this.error = false,
    this.errorText,
    this.helperText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  State<RadixInput> createState() => _RadixInputState();
}

class _RadixInputState extends State<RadixInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: _getHeight(),
          decoration: BoxDecoration(
            color: widget.disabled ? RadixTokens.slate2 : RadixTokens.slate1,
            border: Border.all(
              color: _getBorderColor(),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(RadixTokens.radius3),
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: RadixTokens.space3),
                  child: SizedBox(
                    width: _getIconSize(),
                    height: _getIconSize(),
                    child: widget.prefixIcon,
                  ),
                ),
                const SizedBox(width: RadixTokens.space2),
              ],
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !widget.disabled,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  onChanged: widget.onChanged,
                  style: _getTextStyle(),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: _getTextStyle().copyWith(
                      color: RadixTokens.slate9,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.prefixIcon != null ? 0 : RadixTokens.space3,
                      vertical: _getVerticalPadding(),
                    ),
                  ),
                ),
              ),
              if (widget.suffixIcon != null) ...[
                const SizedBox(width: RadixTokens.space2),
                Padding(
                  padding: const EdgeInsets.only(right: RadixTokens.space3),
                  child: SizedBox(
                    width: _getIconSize(),
                    height: _getIconSize(),
                    child: widget.suffixIcon,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: RadixTokens.space1),
          Text(
            widget.errorText ?? widget.helperText ?? '',
            style: RadixTokens.caption.copyWith(
              color: widget.error ? Colors.red.shade600 : RadixTokens.slate10,
            ),
          ),
        ],
      ],
    );
  }

  double _getHeight() {
    switch (widget.size) {
      case RadixInputSize.small:
        return 32;
      case RadixInputSize.medium:
        return 36;
      case RadixInputSize.large:
        return 40;
    }
  }

  double _getVerticalPadding() {
    switch (widget.size) {
      case RadixInputSize.small:
        return RadixTokens.space1;
      case RadixInputSize.medium:
        return RadixTokens.space2;
      case RadixInputSize.large:
        return RadixTokens.space3;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case RadixInputSize.small:
        return 14;
      case RadixInputSize.medium:
        return 16;
      case RadixInputSize.large:
        return 18;
    }
  }

  Color _getBorderColor() {
    if (widget.error) {
      return Colors.red.shade400;
    }
    if (_isFocused) {
      return RadixTokens.indigo8;
    }
    if (widget.disabled) {
      return RadixTokens.slate5;
    }
    return RadixTokens.slate7;
  }

  TextStyle _getTextStyle() {
    final baseStyle = widget.size == RadixInputSize.small
        ? RadixTokens.caption
        : RadixTokens.body2;

    return baseStyle.copyWith(
      color: widget.disabled ? RadixTokens.slate8 : RadixTokens.slate12,
    );
  }
}