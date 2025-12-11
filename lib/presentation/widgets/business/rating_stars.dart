import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;

  const RatingStars({
    Key? key,
    required this.rating,
    this.size = 20,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? Colors.amber;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          // Full star
          return Icon(Icons.star, size: size, color: starColor);
        } else if (index < rating) {
          // Half star
          return Stack(
            children: [
              Icon(Icons.star_border, size: size, color: starColor),
              ClipRect(
                clipper: _HalfClipper(),
                child: Icon(Icons.star, size: size, color: starColor),
              ),
            ],
          );
        } else {
          // Empty star
          return Icon(Icons.star_border, size: size, color: starColor);
        }
      }),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
