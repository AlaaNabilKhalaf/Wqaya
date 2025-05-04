import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Home/Presentation/Views/view_model/home_cubit.dart';
import 'package:wqaya/Features/Home/Presentation/Widgets/xray_card.dart';


class RayView extends StatefulWidget {
  const RayView({Key? key}) : super(key: key);

  @override
  State<RayView> createState() => _RayViewState();
}

class _RayViewState extends State<RayView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getUserRays(); // 👈 Fetch rays on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F6FB),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: const Color(0xff0094FD),
        title: const Text(
          'سجل الأشعة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: black),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is RayLoading) {
                  return const Center(child: CircularProgressIndicator(
                    backgroundColor: primaryColor,
                  ));
                } else if (state is RayError) {
                  return Center(child: Text('حدث خطأ: ${state.message}', style: const TextStyle(fontFamily: regular)));
                } else if (state is RaySuccess) {
                  final rays = state.rays;
                  if (rays.isEmpty) {
                    return const Center(child: Text('لا توجد أشعة حاليًا.', style: TextStyle(fontFamily: regular)));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: rays.length,
                    itemBuilder: (context, index) {
                      return XRayCard(rayModel: rays[index],);
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0094FD),
        onPressed: () {
          // Add new X-ray record
        },
        child: const Icon(Icons.add_photo_alternate, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xff0094FD),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'سجل الأشعة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: black, fontSize: 24),
          ),
          const SizedBox(height: 8),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final count = (state is RaySuccess) ? state.rays.length : 0;
              return Text(
                'عدد الأشعة : $count',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: semiBold),
              );
            },
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'أبحث في الأشعة',
              hintStyle: const TextStyle(fontFamily: regular),
              filled: true,
              fillColor: const Color(0xffF1F6FB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xff1678F2)),
            ),
            onChanged: (value) {
              // context.read<HomeCubit>().filterRays(value);
            },
          ),
        ],
      ),
    );
  }
}
