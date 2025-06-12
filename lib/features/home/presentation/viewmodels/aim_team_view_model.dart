import 'package:flutter/material.dart';

import '../../domain/models/team_member_model.dart';

class AimTeamViewModel extends ChangeNotifier {
  final List<TeamMemberModel> _teamMembers = [
    TeamMemberModel(
      name: "Dr. Dheeraj Pandey",
      role: "Idea & Creator",
      education: "BHMS, PG Scholar",
      email: "dr.dheeraj.pandey@gmail.com",
      instagram: "dr.dheeraj.pandey",
      profileImageUrl: "assets/team.png",
    ),
    TeamMemberModel(
      name: "Prabhat Mishra",
      role: "Developer & Co-Creator",
      education: "MCA Student",
      email: "prabhatmishra140@gmail.com",
      instagram: "_prabhat_mishra",
      profileImageUrl: "assets/team.png",
    ),
    // Add more as needed
  ];

  final String teamBannerUrl = "assets/teamban.png";

  List<TeamMemberModel> get teamMembers => _teamMembers;
  String get teamBanner => teamBannerUrl;
}
