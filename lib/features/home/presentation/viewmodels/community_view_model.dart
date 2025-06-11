import 'package:flutter/material.dart';

import '../../domain/models/community_model.dart';

class CommunityViewModel extends ChangeNotifier {
  final List<CommunityItem> _items = [
    CommunityItem(
      imageUrl: 'assets/homo.png',
      title: 'Alli Homoeopathy',
      subtitle: 'drkishanprashant',
    ),
    CommunityItem(
      imageUrl: 'assets/homo.png',
      title: 'Homeopathic Case Taking Part 2 - Dr Naman Nigam',
      subtitle: '',
    ),
    CommunityItem(
      imageUrl: 'assets/homo.png',
      title: 'Homeopathic Case Taking Part 3 - Dr Naman Nigam',
      subtitle: '',
    ),
    CommunityItem(
      imageUrl: 'assets/homo.png',
      title: 'Food Safety Officer Recruitment in Madhya Pradesh - MPPSC',
      subtitle: '',
    ),
    // Add more entries as needed
  ];

  List<CommunityItem> get items => _items;
}
