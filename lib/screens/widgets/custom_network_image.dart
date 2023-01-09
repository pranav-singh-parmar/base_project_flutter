import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatefulWidget {
  final bool isCircle;
  final String? imageURL;
  final double? height;
  final double? width;
  final BoxFit? imageFit;

  const CustomNetworkImage(
      {Key? key,
      this.isCircle = false,
      this.imageURL,
      this.height,
      this.width,
      this.imageFit = BoxFit.fill})
      : super(key: key);

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return widget.isCircle
        ? ClipOval(child: _cacheNetworkImage)
        : _cacheNetworkImage;
  }

  CachedNetworkImage get _cacheNetworkImage => CachedNetworkImage(
      imageUrl: widget.imageURL ?? "",
      height: widget.height,
      width: widget.width,
      fit: widget.imageFit,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => const Icon(Icons.error));
}
