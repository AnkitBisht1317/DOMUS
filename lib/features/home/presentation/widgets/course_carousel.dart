import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../viewmodels/course_carousel_view_model.dart';
import '../../domain/models/course_item.dart';

class CourseCarousel extends StatelessWidget {
  const CourseCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseCarouselViewModel>(
      builder: (context, viewModel, _) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: CarouselSlider(
            items: viewModel.courses.map((course) => _buildCourseCard(course, viewModel)).toList(),
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
              onPageChanged: (index, reason) => viewModel.onPageChanged(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourseCard(CourseItem course, CourseCarouselViewModel viewModel) {
    return Container(
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
                    if (course.isNew)
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
                      children: course.iconPaths.map((path) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image.asset(
                          path,
                          width: 20,
                          height: 20,
                        ),
                      )).toList(),
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
                course.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF001F54),
                ),
              ),
              Text(
                course.subtitle,
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
                  'Price: ${course.price} (Discount: ${course.discount})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Date rows
              _buildDateRow('Starts', course.startDate),
              const SizedBox(height: 4),
              _buildDateRow('Ends', course.endDate),
              const SizedBox(height: 10),
              // Buy Now button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed: () => viewModel.buyNow(viewModel.currentIndex),
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
                onPressed: () => viewModel.addToCart(viewModel.currentIndex),
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
} 