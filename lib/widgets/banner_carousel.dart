import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/banner_item.dart';
import '../config/app_config.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerItem> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    final corPrimaria = Color(int.parse(AppConfig.corPrimaria.replaceAll('#', '0xFF')));

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160,
            viewportFraction: 0.88,
            enlargeCenterPage: true,
            autoPlay: widget.banners.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, _) => setState(() => _current = index),
          ),
          items: widget.banners.map((banner) {
            return GestureDetector(
              onTap: () async {
                if (banner.link != null && banner.link!.isNotEmpty) {
                  final uri = Uri.tryParse(banner.link!);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: banner.imagemUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: Colors.grey[200]),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.banners.length > 1) ...[
          const SizedBox(height: 10),
          AnimatedSmoothIndicator(
            activeIndex: _current,
            count: widget.banners.length,
            effect: WormEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: corPrimaria,
              dotColor: corPrimaria.withOpacity(0.25),
            ),
          ),
        ],
      ],
    );
  }
}
