import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_cubit.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_state.dart';
import 'package:wqaya/Features/surgries/presentation/views/add_surgery_view.dart';
import 'package:wqaya/Features/surgries/presentation/views/widgets/surgery_card.dart';

class SurgeryView extends StatefulWidget {
  const SurgeryView({Key? key}) : super(key: key);

  @override
  State<SurgeryView> createState() => _SurgeryViewState();
}

class _SurgeryViewState extends State<SurgeryView>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<SurgeryCubit>().getUserSurgeries();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SurgeryCubit>().onSearchChanged(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
          } else if (state is SearchSurgeriesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: errorColor,
              ),
            );
          } else if (state is DeleteSurgerySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  state.message,
                  style: const TextStyle(fontFamily: regular),
                ),
                backgroundColor: primaryColor,
              ),
            );
          } else if (state is DeleteSurgeryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  "حدث خلال أثناء البحث",
                  style: TextStyle(fontFamily: regular),
                ),
                backgroundColor: errorColor,
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
                  child: _buildSurgeriesList(state),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0094FD),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSurgeriesView(),)).then((_) {
            context.read<SurgeryCubit>().getUserSurgeries();
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSurgeriesList(SurgeryState state) {
    // Handle loading states
    if (state is UserSurgeriesLoading || state is SearchSurgeriesLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(
          backgroundColor: primaryColor,
        ),
      );
    }

    // Handle error states
    else if (state is UserSurgeriesError) {
      return Center(
        key: const ValueKey('error'),
        child: Text(
          'حدث خطأ: ${state.errorMessage}',
          style: const TextStyle(fontFamily: regular),
        ),
      );
    }
    else if (state is SearchSurgeriesError) {
      return Center(
        key: const ValueKey('search_error'),
        child: Text(
          'حدث خطأ في البحث: ${state.message}',
          style: const TextStyle(fontFamily: regular),
        ),
      );
    }

    // Handle success states
    else if (state is UserSurgeriesLoaded) {
      final surgeries = state.surgeries;
      if (surgeries.isEmpty) {
        return const Center(
          key: ValueKey('empty'),
          child: Text(
            'لا توجد عمليات جراحية',
            style: TextStyle(
              fontFamily: medium,
              fontSize: 18,
              color: Color(0xFF6B7280),
            ),
          ),
        );
      }
      return ListView.builder(
        key: const ValueKey('list'),
        padding: const EdgeInsets.all(16),
        itemCount: surgeries.length,
        itemBuilder: (context, index) {
          return SurgeryCard(
            surgery: surgeries[index],
          );
        },
      );
    }

    // Handle search success state
    else if (state is SearchSurgeriesSuccess) {
      final surgeries = state.surgeries;
      if (surgeries.isEmpty) {
        return const Center(
          key: ValueKey('empty_search'),
          child: Text(
            'لا توجد نتائج للبحث',
            style: TextStyle(
              fontFamily: medium,
              fontSize: 18,
              color: Color(0xFF6B7280),
            ),
          ),
        );
      }
      return ListView.builder(
        key: const ValueKey('search_list'),
        padding: const EdgeInsets.all(16),
        itemCount: surgeries.length,
        itemBuilder: (context, index) {
          return SurgeryCard(
            surgery: surgeries[index],
          );
        },
      );
    }

    // Default empty state
    return const SizedBox(key: ValueKey('empty_view'));
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
          const SizedBox(height: 8),
          BlocBuilder<SurgeryCubit, SurgeryState>(
            builder: (context, state) {
              // Update count for both normal and search results
              final count = (state is UserSurgeriesLoaded)
                  ? state.surgeries.length
                  : (state is SearchSurgeriesSuccess)
                  ? state.surgeries.length
                  : 0;
              return Text(
                'عدد العمليات الجراحية : $count',
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontFamily: semiBold),
              );
            },
          ),
          const SizedBox(height: 24),
          TextField(
            controller: searchController,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: regular),
            decoration: InputDecoration(
              hintText: 'ابحث عن العمليات الجراحية الخاصة بك',
              hintStyle: const TextStyle(fontFamily: regular,fontSize: 14),
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
                  // Clear the text field and reload all surgeries
                  searchController.clear();
                  context.read<SurgeryCubit>().getUserSurgeries();
                },
              ),
            ),
            onChanged: _onSearchChanged,
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
        ],
      ),
    );
  }
}