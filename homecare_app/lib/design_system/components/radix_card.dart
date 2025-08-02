import 'package:flutter/material.dart';
import '../tokens.dart';

class RadixCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool elevated;

  const RadixCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadixTokens.radius4),
        child: Container(
          padding: padding ?? const EdgeInsets.all(RadixTokens.space4),
          decoration: BoxDecoration(
            color: RadixTokens.slate1,
            border: Border.all(
              color: RadixTokens.slate6,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(RadixTokens.radius4),
            boxShadow: elevated ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 0),
                blurRadius: 0,
                spreadRadius: 1,
              ),
            ] : null,
          ),
          child: child,
        ),
      ),
    );
  }
}