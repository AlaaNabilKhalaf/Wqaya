import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_cubit.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_state.dart';
import 'package:wqaya/Features/surgries/presentation/views/widgets/add_surgery.dart';
import 'package:wqaya/Features/surgries/presentation/views/widgets/surgery_card.dart';

class SurgeryView extends StatefulWidget {
  const SurgeryView({Key? key}) : super(key: key);

  @override
  State<SurgeryView> createState() => _SurgeryViewState();
}

class _SurgeryViewState extends State<SurgeryView>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SurgeryCubit>().getUserSurgeries();
  }

  @override
  void dispose() {
    searchController.dispose();
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
          'العمليات الجراحية',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: black,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<SurgeryCubit, SurgeryState>(
        listener: (context, state) {
          if (state is UserSurgeriesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildHeader(),
              state is UserSurgeriesLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                      backgroundColor: primaryColor),
                ),
              )
                  : state is UserSurgeriesLoaded
                  ? state.surgeries.isEmpty
                  ? const Expanded(
                child: Center(
                  child: Text(
                    'لا توجد عمليات جراحية',
                    style: TextStyle(
                      fontFamily: medium,
                      fontSize: 18,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              )
                  : Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.surgeries.length,
                  itemBuilder: (context, index) {
                    final surgery = state.surgeries[index];
                    return SurgeryCard(
                      surgery: surgery,
                    );
                  },
                ),
              )
                  : state is UserSurgeriesError
                  ? const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "حدث خطأ أثناء \nاسترجاع البيانات",
                          style: TextStyle(
                            fontFamily: black,
                            fontSize: 20,
                            color: errorColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  : const SizedBox(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0094FD),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSurgeriesScreen(),));
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
            'العمليات الجراحية الخاصة بك',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: regular,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: searchController,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: regular),
            decoration: InputDecoration(
              hintText: 'ابحث عن العمليات الجراحية الخاصة بك',
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
            ),
            onChanged: (value) {
              // Implement search functionality
            },
          ),
        ],
      ),
    );
  }
}