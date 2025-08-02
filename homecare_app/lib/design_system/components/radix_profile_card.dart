import 'package:flutter/material.dart';
import '../tokens.dart';

class RadixProfileCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  const RadixProfileCard({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.onTap,
    this.actions,
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
            color: RadixTokens.slate1,
            border: Border.all(
              color: RadixTokens.slate6,
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
          child: Row(
            children: [
              // 아바타
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: RadixTokens.indigo3,
                  borderRadius: BorderRadius.circular(RadixTokens.radius6),
                ),
                child: avatarUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(RadixTokens.radius6),
                        child: Image.network(
                          avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildDefaultAvatar(),
                        ),
                      )
                    : _buildDefaultAvatar(),
              ),
              const SizedBox(width: RadixTokens.space3),
              
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
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
              
              // 액션 버튼들
              if (actions != null) ...[
                const SizedBox(width: RadixTokens.space2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Icon(
      Icons.person,
      color: RadixTokens.indigo9,
      size: 24,
    );
  }
}