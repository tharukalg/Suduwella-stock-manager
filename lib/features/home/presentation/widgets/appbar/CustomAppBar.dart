import 'package:flutter/material.dart';


const Color brandBlue = Color(0xFF1C4291);

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;

  const CustomAppBar({Key? key, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0, 
      centerTitle: true,
      iconTheme: const IconThemeData(color: brandBlue),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey.withOpacity(0.2), 
          height: 1.0,
        ),
      ),
      title: const Text(
        'SIM Mobile',
        style: TextStyle(
          color: brandBlue,
          fontWeight: FontWeight.w800,
          fontSize: 22,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        AnimatedRefreshIcon(onRefresh: onRefresh),
        const SizedBox(width: 8), 
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AnimatedRefreshIcon extends StatefulWidget {
  final VoidCallback onRefresh;

  const AnimatedRefreshIcon({Key? key, required this.onRefresh}) : super(key: key);

  @override
  _AnimatedRefreshIconState createState() => _AnimatedRefreshIconState();
}

class _AnimatedRefreshIconState extends State<AnimatedRefreshIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    _controller.forward(from: 0.0);
    
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
      )),
      child: IconButton(
        icon: const Icon(Icons.sync_rounded, size: 28),
        color: brandBlue,
        onPressed: _handleRefresh,
        splashRadius: 24, 
      ),
    );
  }
}