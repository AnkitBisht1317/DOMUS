import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../viewmodels/cart_view_model.dart';
import '../viewmodels/home_view_model.dart';
import '../../../../features/notifications/presentation/screens/notification_screen.dart';

class HomeAppBar extends StatefulWidget {
  final VoidCallback onMenuTap;

  const HomeAppBar({
    Key? key,
    required this.onMenuTap,
  }) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  bool _isSearching = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus && _searchController.text.isEmpty) {
      // Only exit search mode if user explicitly taps outside
      // Do not automatically revert the search state
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    // Ensure we wait for the state to update before focusing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Menu icon in circular container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.menu, color: Colors.black87, size: 20),
              onPressed: widget.onMenuTap,
            ),
          ),
          const SizedBox(width: 12),
          // Main search bar container with icons
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xBDD9D9D9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: _isSearching ? 'Search...' : '',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      enabled: _isSearching,
                    ),
                  ),
                  if (!_isSearching) ...[
                    // Search Icon
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black54),
                      onPressed: _startSearch,
                      padding: const EdgeInsets.all(8),
                    ),
                    // Notification Icon
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.black54),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(8),
                    ),
                    // Cart Icon
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black54),
                          onPressed: () {
                            final viewModel = Provider.of<HomeViewModel>(context, listen: false);
                            viewModel.navigateToCart();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                          padding: const EdgeInsets.all(8),
                        ),
                        Consumer<CartViewModel>(
                          builder: (context, cartViewModel, _) {
                            return cartViewModel.cartItems.isEmpty
                                ? const SizedBox.shrink()
                                : Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${cartViewModel.cartItems.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ] else
                    // Close search icon
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: _stopSearch,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}