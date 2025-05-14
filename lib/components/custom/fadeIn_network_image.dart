import 'package:flutter/material.dart';

class FadeInNetworkImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;

  const FadeInNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  @override
  State<FadeInNetworkImage> createState() => _FadeInNetworkImageState();
}

class _FadeInNetworkImageState extends State<FadeInNetworkImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) => Opacity(opacity: _animation.value, child: child),
      child: Image.network(
        widget.imageUrl,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null && !_isLoaded) {
            _isLoaded = true;
            _controller.forward();
          }
          return child;
        },
      ),
    );
  }
}
