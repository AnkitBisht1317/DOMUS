import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/view_models/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6CA8CB),
              Color(0xFF022150),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Profile Section
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: width * 0.08,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        viewModel.userGender == 'Female' 
                            ? 'assets/girl_doctor.png'
                            : 'assets/boy_doctor.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: width * 0.04,
                            ),
                          ),
                          Text(
                            viewModel.userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => viewModel.checkNotifications(),
                      icon: Icon(
                        viewModel.hasUnreadNotifications
                            ? Icons.notifications_active
                            : Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: height * 0.02),
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Menu',
                        style: TextStyle(
                          fontSize: width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF022150),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.1,
                            crossAxisSpacing: width * 0.04,
                            mainAxisSpacing: width * 0.04,
                          ),
                          itemCount: viewModel.menuItems.length,
                          itemBuilder: (context, index) {
                            final menuItem = viewModel.menuItems[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, menuItem.route);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      menuItem.iconPath,
                                      height: height * 0.06,
                                      width: height * 0.06,
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Text(
                                      menuItem.title,
                                      style: TextStyle(
                                        fontSize: width * 0.035,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF022150),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 