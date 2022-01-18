import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieDataCard extends StatelessWidget {
  const MovieDataCard({
    Key? key,
    required this.url,
    required this.title,
    required this.onCardTap,
    this.titleColor,
    this.width,
  }) : super(key: key);

  final String? url;
  final String title;
  final double? width;
  final Color? titleColor;
  final void Function() onCardTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardTap,
      child: SizedBox(
        width: width ?? double.infinity,
        child: Column(
          children: [
            Flexible(
              flex: 8,
              fit: FlexFit.tight,
              child: url == null
                  ? Image.asset(
                      'asset/image/poster_placeholder.png',
                    )
                  : CachedNetworkImage(
                      imageUrl: url!,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Center(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: titleColor ?? Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
