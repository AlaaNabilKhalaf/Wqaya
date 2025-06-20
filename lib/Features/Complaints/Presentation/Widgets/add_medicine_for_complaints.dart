import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';
import 'package:wqaya/Features/Medicine/presentation/widgets/medicine_card.dart';
import 'package:wqaya/Core/Utils/fonts.dart';

class AddMedicineForComplaints extends StatefulWidget {
  final bool isEditing;
  final void Function(List<String>)? onMedicinesSelected;

  const AddMedicineForComplaints({
    super.key,
    this.isEditing = false,
    this.onMedicinesSelected,
  });
  @override
  State<AddMedicineForComplaints> createState() => _AddMedicineForComplaintsState();
}

class _AddMedicineForComplaintsState extends State<AddMedicineForComplaints> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear temporary selections when initializing the screen
    context.read<MedicineCubit>().tempSelectedIds.clear();
    context.read<MedicineCubit>().tempSelectedMedicineName.clear();

    _searchController.addListener(() {
      final keyword = _searchController.text.trim();
      if (keyword.isNotEmpty) {
        context
            .read<MedicineCubit>()
            .searchMedicinesForAdding(keyword: keyword);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildHeader() {
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
            const SizedBox(height: 24),
            TextField(
              controller: _searchController,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                hintText: 'أبحث عن ادوية للاضافة',
                hintStyle: const TextStyle(fontFamily: regular),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon:
                const Icon(Icons.search, color: Color(0xff1678F2)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xff1678F2)),
                  onPressed: () {
                    _searchController.clear();
                    context.read<MedicineCubit>().getUserMedicine();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<MedicineCubit>().getUserMedicine();
        // Clear temporary selections when leaving the screen without confirming
        context.read<MedicineCubit>().tempSelectedIds.clear();
        context.read<MedicineCubit>().tempSelectedMedicineName.clear();
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF1F6FB),
        appBar: AppBar(
          backgroundColor: const Color(0xff0094FD),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear temporary selections when pressing back button
              context.read<MedicineCubit>().tempSelectedIds.clear();
              context.read<MedicineCubit>().tempSelectedMedicineName.clear();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            'إضافة دواء',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: black,
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              buildHeader(),
              Expanded(
                child: BlocBuilder<MedicineCubit, MedicineState>(
                  builder: (context, state) {
                    if (state is SearchMedicineLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if (state is SearchMedicineSuccess) {
                      final medicines = state.medicines;
                      if (medicines.isEmpty) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => Navigator.pop(context),
                          child: const Center(
                            child: Text(
                              'لا توجد نتائج.\nاضغط للعودة',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = medicines[index];
                          if (widget.isEditing ==true){
                            return MedicineCard(
                              medicine: medicine,
                              canBeChosen: true,
                              isEditing: true,
                            );
                          }else {
                            return MedicineCard(
                              medicine: medicine,
                              canBeChosen: true,
                            );
                          }
                        },
                      );
                    } else if (state is MedicineSelectionChanged) {
                      final medicines = state.medicines;
                      if (medicines.isEmpty) {
                        return const Center(
                          child: Text(
                            'لا توجد نتائج.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = medicines[index];
                          if (widget.isEditing ==true){
                            return MedicineCard(
                              medicine: medicine,
                              canBeChosen: true,
                              isEditing: true,
                            );
                          }else {
                            return MedicineCard(
                              medicine: medicine,
                              canBeChosen: true,
                            );
                          }
                        },
                      );
                    } else if (state is SearchMedicineError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message=="Item not found" ?'لم نجد الدواء' : state.message,
                              style: const TextStyle(color: Colors.red,fontFamily: black,fontSize: 24)),
                        ],
                      );
                    } else {
                      return const Center(
                          child: Text('ابدأ بالبحث عن دواء',
                              style: TextStyle(fontFamily: regular)));
                    }
                  },
                ),
              ),
              // Use BlocBuilder to rebuild UI when selection changes
              BlocBuilder<MedicineCubit, MedicineState>(
                builder: (context, state) {
                  // Get fresh reference to cubit to ensure latest state
                  final currentCubit = context.watch<MedicineCubit>();
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: currentCubit.tempSelectedIds.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        key: ValueKey("submit_btn_${currentCubit.tempSelectedIds.length}"),
                        onPressed: () {
                          // Confirm selections by adding temporary selections to permanent selections
                          currentCubit.confirmSelections();
                          // If onMedicinesSelected callback was provided, call it with the selected medicine names
                          if (widget.onMedicinesSelected != null) {
                            widget.onMedicinesSelected!(currentCubit.selectedMedicineName.toList());
                          }
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text(
                          'تأكيد الاختيار ',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0094FD),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    )
                        : const SizedBox.shrink(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}