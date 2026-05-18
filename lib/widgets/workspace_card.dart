import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/utils/common_util.dart';

class WorkspaceCard extends StatelessWidget {
  final String name;
  final String location;
  final double rating;
  final String price;
  final List<String> amenities;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  const WorkspaceCard({
    super.key,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.amenities,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: isDark ? const Color(0xFF1A1D1E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: CommonUtil.bRadius20,
          side: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: CommonUtil.pAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite ? Colors.redAccent : null,
                    ),
                    onPressed: onFavoriteTap,
                  ),
                ],
              ),
              CommonUtil.vGap8,
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  CommonUtil.hGap4,
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              CommonUtil.vGap12,
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      size: 18, color: Colors.amberAccent),
                  CommonUtil.hGap4,
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ],
              ),
              CommonUtil.vGap16,
              Wrap(
                spacing: CommonUtil.s8,
                runSpacing: CommonUtil.s8,
                children: amenities.take(3).map((amenity) {
                  return Container(
                    padding: CommonUtil.pHor10Ver6,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: CommonUtil.bRadius10,
                      border: Border.all(
                          color: theme.primaryColor.withValues(alpha: 0.15)),
                    ),
                    child: Text(
                      amenity,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
              CommonUtil.vGap20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: theme.primaryColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: CommonUtil.bRadius14,
                      ),
                      padding: CommonUtil.pHor20Ver12,
                    ),
                    child: const Text('Book Space',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
