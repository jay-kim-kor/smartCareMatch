import 'package:flutter/material.dart';
import '../tokens.dart';

class RadixServiceCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isActive;
  final Color? iconColor;

  const RadixServiceCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.isActive = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadixTokens.radius4),
        child: Container(
          padding: const EdgeInsets.all(RadixTokens.space4),
          decoration: BoxDecoration(
            color: isActive ? RadixTokens.grass2 : RadixTokens.slate1,
            border: Border.all(
              color: isActive ? RadixTokens.grass6 : RadixTokens.slate6,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(RadixTokens.radius4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive 
                      ? RadixTokens.grass3 
                      : RadixTokens.slate3,
                  borderRadius: BorderRadius.circular(RadixTokens.radius3),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? (isActive 
                      ? RadixTokens.grass9 
                      : RadixTokens.slate9),
                  size: 24,
                ),
              ),
              const SizedBox(height: RadixTokens.space3),
              Text(
                title,
                style: RadixTokens.body1.copyWith(
                  color: RadixTokens.slate12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: RadixTokens.space1),
                Text(
                  subtitle!,
                  style: RadixTokens.body2.copyWith(
                    color: RadixTokens.slate10,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}