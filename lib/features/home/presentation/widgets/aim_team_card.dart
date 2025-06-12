import 'package:flutter/material.dart';

import '../../domain/models/team_member_model.dart';

class AimTeamCard extends StatelessWidget {
  final TeamMemberModel member;
  final String bannerUrl;

  const AimTeamCard({
    super.key,
    required this.member,
    required this.bannerUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background logo (low opacity behind text)
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/logo.png',
                  width: screenWidth * 0.55,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Column(
            children: [
              // Banner
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  bannerUrl,
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),

              // Space for profile image (which overlaps)
              const SizedBox(height: 45),

              // Member details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Text(
                      member.role,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.052,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.name,
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (member.education.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        member.education,
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (member.email.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        member.email,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 1),
                    Text(
                      "Instagram : ${member.instagram}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),

          // Profile Image - overlapping banner & card body
          Positioned(
            top: 20,
            left: (screenWidth / 2) - 70,
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(member.profileImageUrl),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
