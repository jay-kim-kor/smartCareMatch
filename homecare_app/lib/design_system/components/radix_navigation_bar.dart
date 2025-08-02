import 'package:flutter/material.dart';
import '../tokens.dart';

class RadixNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<RadixNavigationItem> items;
  final Widget? centerButton;

  const RadixNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.centerButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RadixTokens.slate1,
        border: Border(
          top: BorderSide(
            color: RadixTokens.slate6,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              // 왼쪽 아이템
              if (items.isNotEmpty)
                Expanded(
                  child: _buildNavigationItem(0, items[0]),
                ),
              // 중앙 버튼
              if (centerButton != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: RadixTokens.space4),
                  child: centerButton!,
                ),
              // 오른쪽 아이템
              if (items.length > 1)
                Expanded(
                  child: _buildNavigationItem(1, items[1]),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(int index, RadixNavigationItem item) {
    final isSelected = index == currentIndex;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: RadixTokens.space2,
          vertical: RadixTokens.space2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              color: isSelected ? RadixTokens.indigo9 : RadixTokens.slate9,
              size: 22,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                item.label,
                style: RadixTokens.caption.copyWith(
                  color: isSelected ? RadixTokens.indigo11 : RadixTokens.slate9,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadixNavigationItem {
  final IconData icon;
  final String label;

  const RadixNavigationItem({
    required this.icon,
    required this.label,
  });
}