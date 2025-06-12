import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Medicine/presentation/views/add_medicine_view.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';
import 'package:wqaya/Features/Medicine/presentation/widgets/medicine_card.dart';

class MedicineView extends StatefulWidget {
  const MedicineView({Key? key}) : super(key: key);

  @override
  State<MedicineView> createState() => _MedicineViewState();
}

class _MedicineViewState extends State<MedicineView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<MedicineCubit>().getUserMedicine();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        // If search field is empty, fetch all medicines
        context.read<MedicineCubit>().getUserMedicine();
      } else {
        // Otherwise perform search
        context.read<MedicineCubit>().searchGeneralMedicine(keyword: query);
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
          'الأدوية',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: black,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<MedicineCubit, MedicineState>(
        listener: (context, state) {
          // Handle state changes if needed
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
                    if (state is UserMedicineLoading || state is SearchMedicineLoading) {
                      return const Center(
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(
                          backgroundColor: primaryColor,
                        ),
                      );
                    }
                    // Handle error states
                    else if (state is UserMedicineError) {
                      return Center(
                        key: const ValueKey('error'),
                        child: Text(
                          'حدث خطأ: ${state.message}',
                          style: const TextStyle(fontFamily: regular),
                        ),
                      );
                    }
                    else if (state is SearchMedicineError) {
                      return Center(
                        key: const ValueKey('search_error'),
                        child: Text(
                          'حدث خطأ في البحث: ${state.message}',
                          style: const TextStyle(fontFamily: regular),
                        ),
                      );
                    }
                    // Handle success states
                    else if (state is UserMedicineLoaded) {
                      final medicines = state.medicines;
                      if (medicines.isEmpty) {
                        return const Center(
                          key: ValueKey('empty'),
                          child: Text('لا توجد أدوية.', style: TextStyle(fontFamily: regular)),
                        );
                      }
                      return ListView.builder(
                        key: const ValueKey('list'),
                        padding: const EdgeInsets.all(16),
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          return MedicineCard(
                            medicine: medicines[index],
                            canBeChosen: false,
                          );
                        },
                      );
                    }
                    // Handle search success state
                    else if (state is SearchMedicineSuccess) {
                      final medicines = state.medicines;
                      if (medicines.isEmpty) {
                        return const Center(
                          key: ValueKey('empty_search'),
                          child: Text('لا توجد نتائج للبحث.', style: TextStyle(fontFamily: regular)),
                        );
                      }
                      return ListView.builder(
                        key: const ValueKey('search_list'),
                        padding: const EdgeInsets.all(16),
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          return MedicineCard(
                            medicine: medicines[index],
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
        onPressed: () {
          context.read<MedicineCubit>().clearSelections();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMedicineView()),
          );
        },
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
            'الأدوية الخاصة بك',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontFamily: regular),
          ),
          const SizedBox(height: 8),
          BlocBuilder<MedicineCubit, MedicineState>(
            builder: (context, state) {
              // Update count for both normal and search results
              final count = (state is UserMedicineLoaded)
                  ? state.medicines.length
                  : (state is SearchMedicineSuccess)
                  ? state.medicines.length
                  : 0;
              return Text(
                'عدد الأدوية : $count',
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
              hintText: 'أبحث عن الأدوية الخاصة بك',
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
                  // Clear the text field and reload all medicines
                  _searchController.clear();
                  context.read<MedicineCubit>().getUserMedicine();
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