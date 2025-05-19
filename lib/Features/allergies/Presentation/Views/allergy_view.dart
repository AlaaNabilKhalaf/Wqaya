import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/allergies/Presentation/Views/add_allergy_view.dart';

import 'package:wqaya/Features/allergies/Presentation/Views/view_model/allergy_cubit.dart';
import 'package:wqaya/Features/allergies/Presentation/Views/widgets/allergy_card.dart';

class AllergyView extends StatefulWidget {
  const AllergyView({Key? key}) : super(key: key);

  @override
  State<AllergyView> createState() => _AllergyViewState();
}

class _AllergyViewState extends State<AllergyView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<AllergyCubit>().getUserAllergies();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        // If search field is empty, fetch all allergies
        context.read<AllergyCubit>().getUserAllergies();
      } else {
        // Otherwise perform search
        context.read<AllergyCubit>().searchUserAllergies(keyword: query);
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
        backgroundColor: const Color(0xff0094FD),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          'الحساسية',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: black,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<AllergyCubit, AllergyState>(
        listener: (context, state) {
          // Handle state changes if needed
          if (state is DeleteAllergySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حذف الحساسية بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is DeleteAllergyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل في حذف الحساسية: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildHeader(),
              Expanded(
                child: AnimatedSwitcher(
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
                    // Handle loading states
                    if (state is UserAllergyLoading || state is SearchAllergyLoading) {
                      return const Center(
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(
                          backgroundColor: primaryColor,
                        ),
                      );
                    }
                    // Handle error states
                    else if (state is UserAllergyError) {
                      return Center(
                        key: const ValueKey('error'),
                        child: Text(
                          'حدث خطأ: ${state.message}',
                          style: const TextStyle(fontFamily: regular),
                        ),
                      );
                    }
                    else if (state is SearchAllergyError) {
                      return Center(
                        key: const ValueKey('search_error'),
                        child: Text(
                          'حدث خطأ في البحث: ${state.message}',
                          style: const TextStyle(fontFamily: regular),
                        ),
                      );
                    }
                    // Handle success states
                    else if (state is UserAllergyLoaded) {
                      final allergies = state.allergies;
                      if (allergies.isEmpty) {
                        return const Center(
                          key: ValueKey('empty'),
                          child: Text('لا توجد حساسية مسجلة.', style: TextStyle(fontFamily: regular)),
                        );
                      }
                      return ListView.builder(
                        key: const ValueKey('list'),
                        padding: const EdgeInsets.all(16),
                        itemCount: allergies.length,
                        itemBuilder: (context, index) {
                          return AllergyCard(
                            allergy: allergies[index],
                            canBeChosen: false,
                          );
                        },
                      );
                    }
                    // Handle search success state
                    else if (state is SearchAllergySuccess) {
                      final allergies = state.allergies;
                      if (allergies.isEmpty) {
                        return const Center(
                          key: ValueKey('empty_search'),
                          child: Text('لا توجد نتائج للبحث.', style: TextStyle(fontFamily: regular)),
                        );
                      }
                      return ListView.builder(
                        key: const ValueKey('search_list'),
                        padding: const EdgeInsets.all(16),
                        itemCount: allergies.length,
                        itemBuilder: (context, index) {
                          return AllergyCard(
                            allergy: allergies[index],
                            canBeChosen: false,
                          );
                        },
                      );
                    }
                    else {
                      return const SizedBox(key: ValueKey('empty_view'));
                    }
                  }(),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0094FD),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAllergyView(),
            )),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
            'الحساسية الخاصة بك',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontFamily: regular),
          ),
          const SizedBox(height: 8),
          BlocBuilder<AllergyCubit, AllergyState>(
            builder: (context, state) {
              // Update count for both normal and search results
              final count = (state is UserAllergyLoaded)
                  ? state.allergies.length
                  : (state is SearchAllergySuccess)
                  ? state.allergies.length
                  : 0;
              return Text(
                'عدد الحساسية : $count',
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontFamily: semiBold),
              );
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(
              hintText: 'أبحث عن الحساسية الخاصة بك',
              hintStyle: const TextStyle(fontFamily: regular),
              filled: true,
              fillColor: const Color(0xffF1F6FB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xff1678F2),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Color(0xff1678F2)),
                onPressed: () {
                  // Clear the text field and reload all allergies
                  _searchController.clear();
                  context.read<AllergyCubit>().getUserAllergies();
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