import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Home/Presentation/Views/view_model/home_cubit.dart';
import 'package:wqaya/Features/Home/Presentation/Views/view_model/model/home_models.dart';
import 'package:wqaya/Features/Home/Presentation/Widgets/full_screen_image_view.dart';

class XRayCard extends StatelessWidget {
  final RayModel rayModel;

  const XRayCard({super.key, required this.rayModel});

  @override
  Widget build(BuildContext context) {
    var hCubit = context.read<HomeCubit>();
    final formattedDate =
        DateFormat.yMMMMd('ar').format(DateTime.parse(rayModel.rayDate));
    void showOptionsMenu(BuildContext context) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: primaryColor),
                      SizedBox(
                        width: 10,
                      ),
                      Text('تعديل', style: TextStyle(fontFamily: regular)),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: errorColor),
                      SizedBox(
                        width: 10,
                      ),
                      Text('حذف', style: TextStyle(fontFamily: regular)),
                    ],
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await hCubit.deleteUserRay(rayId: rayModel.id);
                    await hCubit.getUserRays();

                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return GestureDetector(
      onLongPress: () => showOptionsMenu(context),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImageView(imageUrl: rayModel.imageUrl),
          ),
        );
      },
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) async {

        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: rayModel.imageUrl,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("نوع الأشعة: ${rayModel.rayType}",
                        style:
                            const TextStyle(fontFamily: regular, fontSize: 20)),
                    const SizedBox(height: 8),
                    Text("السبب: ${rayModel.reason}",
                        style:
                            const TextStyle(fontFamily: regular, fontSize: 18)),
                    const SizedBox(height: 8),
                    Text("الجزء المصاب: ${rayModel.bodyPart}",
                        style:
                            const TextStyle(fontFamily: regular, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("تاريخ الأشعة: $formattedDate",
                        style:
                            const TextStyle(fontFamily: regular, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
