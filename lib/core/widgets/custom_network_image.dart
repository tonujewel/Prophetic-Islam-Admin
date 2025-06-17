import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String? placeHolderPath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double? borderRadius;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeHolderPath,
    this.height,
    this.width,
    this.fit,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl == ""
        ? Image.asset(
            placeHolderPath ?? "assets/images/placeholder.png",
            fit: fit,
            height: height,
            width: width,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            child: CachedNetworkImage(
              height: height,
              width: width,
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) => Image.asset(
                placeHolderPath ?? "assets/images/placeholder.png",
                fit: fit,
                height: height,
                width: width,
              ),
              errorWidget: (context, url, error) => Image.asset(
                placeHolderPath ?? "assets/images/placeholder.png",
                fit: fit,
                height: height,
                width: width,
              ),
            ),
          );
  }
}
