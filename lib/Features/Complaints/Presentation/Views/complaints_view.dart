import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/add_complaints_view.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/view_model/complaint_cubit.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/view_model/complaint_state.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaint_card.dart';

class ComplaintsView extends StatefulWidget {
  const ComplaintsView({Key? key}) : super(key: key);

  @override
  State<ComplaintsView> createState() => _ComplaintsViewState();
}

class _ComplaintsViewState extends State<ComplaintsView>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<ComplaintsCubit>().getUserComplaints();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ComplaintsCubit>().searchComplaints(query);
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
          'الشكاوى',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: black,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<ComplaintsCubit, ComplaintState>(
        listener: (context, state) {
          if (state is UserComplaintsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: errorColor,
              ),
            );
          } else if (state is SearchComplaintsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: errorColor,
              ),
            );
          } else if (state is DeleteComplaintSuccess) {
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
            // Refresh complaints list after successful deletion
            context.read<ComplaintsCubit>().getUserComplaints();
          } else if (state is DeleteComplaintError) {
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
          } else if (state is AddComplaintSuccess) {
            // Refresh complaints list after successful addition
            context.read<ComplaintsCubit>().getUserComplaints();
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
                  child: _buildComplaintsList(state),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0094FD),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddComplaintView()),
          ).then((_) {
            context.read<ComplaintsCubit>().getUserComplaints();
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildComplaintsList(ComplaintState state) {
    // Handle loading states
    if (state is UserComplaintsLoading || state is SearchComplaintsLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(
          backgroundColor: primaryColor,
        ),
      );
    }
    else if (state is UserComplaintsError) {
      return Center(
        key: const ValueKey('error'),
        child: Text(
          'حدث خطأ: ${state.message}',
          style: const TextStyle(fontFamily: regular),
        ),
      );
    }
    else if (state is SearchComplaintsError) {
      return Center(
        key: const ValueKey('search_error'),
        child: Text(
          'حدث خطأ في البحث: ${state.message}',
          style: const TextStyle(fontFamily: regular),
        ),
      );
    }

    // Handle success states
    else if (state is UserComplaintsLoaded) {
      final complaints = state.complaints;
      if (complaints.isEmpty) {
        return const Center(
          key: ValueKey('empty'),
          child: Text(
            'لا توجد شكاوى مسجلة',
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
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          return ComplaintCard(
            complaint: complaints[index],
          );
        },
      );
    }

    // Handle search success state
    else if (state is SearchComplaintsSuccess) {
      final complaints = state.complaints;
      if (complaints.isEmpty) {
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
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          return ComplaintCard(
            complaint: complaints[index],
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
            'الشكاوى الخاصة بك',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: regular,
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<ComplaintsCubit, ComplaintState>(
            builder: (context, state) {
              // Update count for both normal and search results
              final count = (state is UserComplaintsLoaded)
                  ? state.complaints.length
                  : (state is SearchComplaintsSuccess)
                  ? state.complaints.length
                  : 0;
              return Text(
                'عدد الشكاوى : $count',
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
              hintText: 'ابحث عن الشكاوى الخاصة بك',
              hintStyle: const TextStyle(fontFamily: regular, fontSize: 14),
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
                  // Clear the text field and reload all complaints
                  searchController.clear();
                  context.read<ComplaintsCubit>().getUserComplaints();
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