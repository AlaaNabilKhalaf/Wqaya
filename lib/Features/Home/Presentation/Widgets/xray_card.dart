import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Features/Home/Presentation/Views/view_model/model/home_models.dart';
import 'package:wqaya/Features/Home/Presentation/Widgets/full_screen_image_view.dart';

class XRayCard extends StatelessWidget {
  final RayModel rayModel;
  const XRayCard({super.key, required this.rayModel});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMMd('ar').format(DateTime.parse(rayModel.rayDate));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImageView(imageUrl: rayModel.imageUrl),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: rayModel.imageUrl, // Use a unique tag
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: rayModel.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: primaryColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("نوع الأشعة: ${rayModel.rayType}",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text("السبب: ${rayModel.reason}",
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text("الجزء المصاب: ${rayModel.bodyPart}",
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text("تاريخ الأشعة: $formattedDate",
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
