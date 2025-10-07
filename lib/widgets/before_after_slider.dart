import 'package:flutter/material.dart';
import 'dart:async';

class BeforeAfterSlider extends StatefulWidget {
  final String beforeImage;
  final String afterImage;
  final bool autoAnimate;
  
  const BeforeAfterSlider({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    this.autoAnimate = true,
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    if (widget.autoAnimate) {
      _startAutoAnimation();
    }
  }
  
  void _startAutoAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      if (_controller.status == AnimationStatus.completed) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
    _controller.forward();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRect(
          child: Stack(
            children: [
              // After image (full)
              Positioned.fill(
                child: Image.asset(
                  widget.afterImage,
                  fit: BoxFit.cover,
                ),
              ),
              
              // Before image (clipped)
              Positioned.fill(
                child: ClipRect(
                  clipper: _BeforeClipper(_animation.value),
                  child: Image.asset(
                    widget.beforeImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Divider line
              Positioned(
                left: MediaQuery.of(context).size.width * _animation.value - 2,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Slider handle
              Positioned(
                left: MediaQuery.of(context).size.width * _animation.value - 20,
                top: MediaQuery.of(context).size.height * 0.35,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.compare_arrows,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
              
              // Labels
              Positioned(
                top: 40,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'BEFORE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'AFTER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BeforeClipper extends CustomClipper<Rect> {
  final double progress;
  
  _BeforeClipper(this.progress);
  
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * progress, size.height);
  }
  
  @override
  bool shouldReclip(_BeforeClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
