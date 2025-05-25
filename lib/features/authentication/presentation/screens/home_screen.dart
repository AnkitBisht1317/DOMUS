import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String fullName;
  final String gender;

  const HomeScreen({
    super.key,
    required this.fullName,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                        gender == 'Female' 
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
                            fullName,
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
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_outlined,
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
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            final titles = [
                              'Study Material',
                              'Assignments',
                              'Tests',
                              'Progress',
                              'Schedule',
                              'Resources'
                            ];
                            return Container(
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
                                    'assets/books.png',
                                    height: height * 0.06,
                                    width: height * 0.06,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    titles[index],
                                    style: TextStyle(
                                      fontSize: width * 0.035,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF022150),
                                    ),
                                  ),
                                ],
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