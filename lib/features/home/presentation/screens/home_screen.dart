import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Book {
  final String title;
  final String imagePath;
  final double fontSize;

  Book({
    required this.title, 
    required this.imagePath,
    this.fontSize = 12,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  final List<Widget> courseCards = [];

  @override
  void initState() {
    super.initState();
    _configureSystemUI();
    _initializeCards();
  }

  void _configureSystemUI() {
    // Set the status bar and navigation bar to be transparent
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    // Enable edge-to-edge mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }

  void _initializeCards() {
    final List<Map<String, dynamic>> courseItems = [
      {
        'title': 'Vishal Megamart',
        'subtitle': 'Complete batch',
        'price': '₹999',
        'discount': '20%',
        'startDate': '2025-12-01',
        'endDate': '2025-12-31',
        'isNew': true,
      },
      {
        'title': 'AIIMS',
        'subtitle': 'Special batch',
        'price': '₹1299',
        'discount': '15%',
        'startDate': '2025-11-15',
        'endDate': '2025-12-15',
        'isNew': true,
      },
      {
        'title': 'UPSC',
        'subtitle': 'Premium batch',
        'price': '₹1499',
        'discount': '25%',
        'startDate': '2025-12-10',
        'endDate': '2026-01-10',
        'isNew': true,
      },
    ];

    courseCards.addAll(
      courseItems.map((item) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Card(
          elevation: 8,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // New tag and icons row
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (item['isNew'])
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF7F6A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'New',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/books.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          Image.asset(
                            'assets/books.png',
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Course logo
                Container(
                  width: 70,
                  height: 70,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: Image.asset('assets/books.png'),
                ),
                const SizedBox(height: 10),
                // Course title
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF001F54),
                  ),
                ),
                Text(
                  item['subtitle'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                // Price container
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'Price: ${item['price']} (Discount: ${item['discount']})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Date rows
                _buildDateRow('Starts', item['startDate']),
                const SizedBox(height: 4),
                _buildDateRow('Ends', item['endDate']),
                const SizedBox(height: 10),
                // Buy Now button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Add to cart link
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(6),
                  ),
                  child: const Text(
                    'Add to cart',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // List of book items with their details
    List<Book> bookItems = [
      Book(
        title: 'NTET',
        imagePath: 'assets/books.png',
        fontSize: 12,
      ),
      Book(
        title: 'Entrance',
        imagePath: 'assets/exam.png',
        fontSize: 12,
      ),
      Book(
        title: 'Subject Wise MCQ',
        imagePath: 'assets/test.png',
        fontSize: 9,
      ),
      Book(
        title: 'Medicos Corner',
        imagePath: 'assets/medicos_corner.png',
        fontSize: 9,
      ),
      Book(
        title: 'Paid Mock',
        imagePath: 'assets/medicine.png',
        fontSize: 12,
      ),
      Book(
        title: 'Study Notes',
        imagePath: 'assets/study_notes.png',
        fontSize: 11,
      ),
      Book(
        title: 'HMM',
        imagePath: 'assets/hmm.png',
        fontSize: 12,
      ),
      Book(
        title: 'Aphorism',
        imagePath: 'assets/aphorism.png',
        fontSize: 11,
      ),
      Book(
        title: 'OP',
        imagePath: 'assets/op.png',
        fontSize: 12,
      ),
      Book(
        title: 'Therapeutics',
        imagePath: 'assets/therapeutic.png',
        fontSize: 9,
      ),
    ];

    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Stack(
          children: [
            // Background blue gradient that extends behind the status bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: height * 0.35,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF022150),
                      Color(0xFF022150),
                      Color(0xFF022150),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTopBar(),
                    _buildHeroBanner(),
                    _buildMainContent(bookItems),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: const [
          Icon(Icons.menu, color: Colors.white),
          Spacer(),
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.notifications_none, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/home_page_banner.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(List<Book> bookItems) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Domus Homoeopathica',
              style: TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryTabs(),
          _buildIconGrid(bookItems),
          _buildQuestionCard(),
          _buildTestSeriesButtons(),
          _buildCoursePromo(),
          _buildMyLectures(),
          _buildDoctorWritings(),
          _buildJobPortal(),
          _buildTestimonial(),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _TabItem("All", isSelected: true),
          _TabItem("Exam", isSelected: false),
          _TabItem("Study", isSelected: false),
          _TabItem("Revision", isSelected: false),
          _TabItem("Community", isSelected: false),
        ],
      ),
    );
  }

  Widget _buildIconGrid(List<Book> bookItems) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        children: [
          // First row of icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bookItems.take(5).map((book) => Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFF1B3A63),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  book.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 4),
          // First row of text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bookItems.take(5).map((book) => Container(
              width: 65,
              child: Text(
                book.title,
                style: TextStyle(
                  fontSize: book.fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          // Second row of icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bookItems.skip(5).take(5).map((book) => Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFF1B3A63),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  book.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 4),
          // Second row of text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bookItems.skip(5).take(5).map((book) => Container(
              width: 65,
              child: Text(
                book.title,
                style: TextStyle(
                  fontSize: book.fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF001F54),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Header section
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(
                  'Question of the Day',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'May 26',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Content Card
          Container(
            margin: const EdgeInsets.only(bottom: 1), // To ensure perfect rounded corners
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question text
                  const Text(
                    'Who is the current Pradhan Mantri Of INDIA ? ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Options
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: const [
                              Text(
                                'A.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Amit Shah',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Repeat for other options with the same styling
                  _buildOptionCard('B', 'Jatin Shah'),
                  _buildOptionCard('C', 'Narendra Modi'),
                  _buildOptionCard('D', 'Nirav Modi'),
                  
                  const SizedBox(height: 16),
                  // Bottom buttons
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: const Text(
                          'Explain',
                          style: TextStyle(
                            color: Color(0xFF001F54),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: const Text(
                          'More',
                          style: TextStyle(
                            color: Color(0xFF001F54),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String prefix, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(
                  '$prefix.',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestSeriesButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8EEF9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFD0D9E8),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Test Series',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF001F54),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF001F54),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Free Mock',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.only(left: 8),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF001F54),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Paid Mock',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoursePromo() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: CarouselSlider(
        items: courseCards,
        options: CarouselOptions(
          height: 500,
          aspectRatio: 16/9,
          viewportFraction: 0.8,
          initialPage: 1,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          enlargeCenterPage: true,
          enlargeFactor: 0.25,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDateRow(String label, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Image.asset(
            'assets/books.png',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $date',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyLectures() {
    final lectures = ["Physics", "Chemistry", "Maths", "Physics 2"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text("My Lectures", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...lectures.map((subject) => ListTile(
          title: Text("$subject || Lecture 1"),
          subtitle: const LinearProgressIndicator(value: 0.6),
          leading: const Icon(Icons.play_circle_outline),
          trailing: const Icon(Icons.more_vert),
        )),
      ],
    );
  }

  Widget _buildDoctorWritings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text("Doctor's Writings", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...List.generate(3, (index) => ListTile(
          title: Text("Card Title ${index + 1}"),
          leading: CircleAvatar(backgroundColor: Colors.blue[200]),
          trailing: const Icon(Icons.chevron_right),
        )),
      ],
    );
  }

  Widget _buildJobPortal() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/job_banner.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonial() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              Text("Congratulations", style: TextStyle(color: Colors.blue)),
              SizedBox(height: 8),
              Text("Dr. Abhishek Shukla"),
              Text("NET 2024 Certified - Madhya Pradesh"),
              SizedBox(height: 8),
              Text(
                "The language used in this book is simple and easy to grasp...",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _TabItem(this.title, {required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: const BoxConstraints(
            minWidth: 80, // Fixed minimum width for more square shape
            minHeight: 32, // Fixed height for more square shape
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE7F0FF) : Colors.white,
            border: Border.all(
              color: const Color(0xFF001F54),
              width: 0.8, // Slightly thinner border
            ),
            borderRadius: BorderRadius.circular(8), // Less rounded corners
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: const Color(0xFF001F54),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
