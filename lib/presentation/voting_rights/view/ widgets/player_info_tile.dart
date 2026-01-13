import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class PlayerInfoTile extends StatelessWidget {
  final String name;
  final String position;
  final String imageUrl;

  const PlayerInfoTile({super.key, required this.name, required this.position, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fieldBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 14))),
          Text(position, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        ],
      ),
    );
  }
}