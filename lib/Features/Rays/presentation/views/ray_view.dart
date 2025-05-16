import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Rays/presentation/views/add_ray_view.dart';
import 'package:wqaya/Features/Rays/presentation/views/view_model/ray_cubit.dart';
import 'package:wqaya/Features/Rays/presentation/widgets/xray_card.dart';

class RayView extends StatefulWidget {
  const RayView({super.key});

  @override
  State<RayView> createState() => _RayViewState();
}

class _RayViewState extends State<RayView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RayCubit>().getUserRays();
  }
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        context.read<RayCubit>().getUserRays();
      } else {
        context.read<RayCubit>().searchRays(keyword: query);
      }
    });
  }
  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
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
        scrolledUnderElevation: 0,
        title: const Text(
          'سجل الأشعة',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: black),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: BlocConsumer<RayCubit, RayCubitState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: () {
                    if (state is RayLoading || state is SearchRaysLoading) {
                      return const Center(
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(
                          backgroundColor: primaryColor,
                        ),
                      );
                    }
                    else if (state is RayError) {
                      return Center(
                        key: const ValueKey('error'),
                        child: Text(
                          'حدث خطأ: ${state.message}',
                          style: const TextStyle(fontFamily: regular),
                        ),
                      );
                    }
                    else if (state is SearchRaysError) {
                      return Center(
                        key: const ValueKey('search_error'),
                        child: Text(
                          'حدث خطأ في البحث: ${state.message}',
                          style: const TextStyle(fontFamily: regular),
                        ),
                      );
                    }
                    else if (state is RaySuccess) {
                      final rays = state.rays;
                      if (rays.isEmpty) {
                        return const Center(
                          key: ValueKey('empty'),
                          child: Text('لا توجد نتائج.', style: TextStyle(fontFamily: regular)),
                        );
                      }
                      return ListView.builder(
                        key: const ValueKey('list'),
                        padding: const EdgeInsets.all(16),
                        itemCount: rays.length,
                        itemBuilder: (context, index) {
                          return XRayCard(rayModel: rays[index]);
                        },
                      );
                    }
                    else if (state is SearchRaysSuccess) {
                      final rays = state.rays;
                      if (rays.isEmpty) {
                        return const Center(
                          key: ValueKey('empty_search'),
                          child: Text('لا توجد نتائج للبحث.', style: TextStyle(fontFamily: regular)),
                        );
                      }
                      return ListView.builder(
                        key: const ValueKey('search_list'),
                        padding: const EdgeInsets.all(16),
                        itemCount: rays.length,
                        itemBuilder: (context, index) {
                          return XRayCard(rayModel: rays[index]);
                        },
                      );
                    }
                    else {
                      return const SizedBox(key: ValueKey('empty_view'));
                    }
                  }(),
                );
              },
              listener: (context, state) {
                if (state is DeleteRaySuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        "تم الحذف بنجاح",
                        style: TextStyle(fontFamily: regular),
                      ),
                      backgroundColor: primaryColor,
                    ),
                  );
                  context.read<RayCubit>().getUserRays();
                } else if (state is DeleteRayError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        state.message,
                        style: const TextStyle(fontFamily: regular),
                      ),
                      backgroundColor: errorColor,
                    ),
                  );
                } else if (state is AddRaySuccess) {
                  context.read<RayCubit>().getUserRays();
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0094FD),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddRayScreen(),
              )).then((_) {
            context.read<RayCubit>().getUserRays();
          });
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
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: black,
                fontSize: 24),
          ),
          const SizedBox(height: 8),
          BlocBuilder<RayCubit, RayCubitState>(
            builder: (context, state) {
              final count = (state is RaySuccess)
                  ? state.rays.length
                  : (state is SearchRaysSuccess)
                  ? state.rays.length
                  : 0;
              return Text(
                'عدد الأشعة : $count',
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontFamily: semiBold),
              );
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _searchController,
            onTapOutside: (event) =>   FocusManager.instance.primaryFocus?.unfocus(),
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
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Color(0xff1678F2)),
                onPressed: () {
                  _searchController.clear();
                  context.read<RayCubit>().getUserRays();
                },
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ],
      ),
    );
  }
}