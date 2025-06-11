import 'package:flutter/material.dart';

import '../../domain/models/community_model.dart';

class CommunityTile extends StatelessWidget {
  final CommunityItem item;

  const CommunityTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF204771),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(item.imageUrl),
            radius: width * 0.06,
          ),
          title: Text(
            item.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: item.subtitle.isNotEmpty
              ? Text(
                  item.subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: width * 0.03,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
