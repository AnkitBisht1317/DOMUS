import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/aim_team_view_model.dart';
import '../widgets/aim_team_card.dart';

class AimTeamDrawer extends StatelessWidget {
  const AimTeamDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AimTeamViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF022150),
      appBar: AppBar(
        backgroundColor: const Color(0xFF022150),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: screenWidth * 0.06),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Team AIM Homoeopathy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView.builder(
          itemCount: viewModel.teamMembers.length,
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          itemBuilder: (context, index) {
            final member = viewModel.teamMembers[index];
            return AimTeamCard(member: member, bannerUrl: viewModel.teamBanner);
          },
        ),
      ),
    );
  }
}
