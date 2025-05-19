import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/global_variables.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/analysis_view.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/complaints_view.dart';
import 'package:wqaya/Features/Medicine/presentation/views/medicine_view.dart';
import 'package:wqaya/Features/Rays/presentation/views/ray_view.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_visibility__cubit.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Widgets/complaints_home_widget.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Widgets/home_container.dart';
import 'package:wqaya/Features/allergies/Presentation/Views/allergy_view.dart';
import 'package:wqaya/Features/surgries/presentation/views/surgries_view.dart';

import '../../../../Core/widgets/custom_home_app_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
    @override
  void initState()  {
      // BlocProvider.of<ProfileImageCubit>(context).imgFile =  CacheHelper().getData(key: 'profileImage') ;
      currentPassword = CacheHelper().getData(key: 'currentPassword');
      print("kkkkkkkkkkkkkkkkkkkkkkkkkkk$currentPassword");
      // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Map<String, String> homeContainerItems = {
      "analysis": AssetsData.analysisPicture2,
      "xray": AssetsData.xrayPicture,
      "medicine": AssetsData.medicineBottle,
      "surgery": AssetsData.surgeryPicture,
    };
    final Set<StatefulWidget> homeScreens = {
      const AnalysisView(),
      const RayView(),
      const MedicineView(),
      const SurgeryView(),
    };
    final List<MapEntry<String, String>> itemsList =
        homeContainerItems.entries.toList();
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: HomeCustomAppBar()),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true, // Needed inside scrollable views
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.9, // Normal rectangular shape
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      context.read<BottomNavVisibilityCubit>().hide();
                      Navigator.of(context)
                          .push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          homeScreens.toList()[index],
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            final tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      ).then((_) {
                        if(context.mounted) {
                          context.read<BottomNavVisibilityCubit>().show();
                        }
                      });
                    },
                    child: HomeContainer(
                      text: itemsList[index].key,
                      image: itemsList[index].value,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    ComplaintsHomeWidget(text : "الشكاوي",image: AssetsData.complaints,screen: ComplaintsView(),),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    ComplaintsHomeWidget(text : "الحساسية",image: AssetsData.allergies,screen: AllergyView(),),
                  ],
                ),
              ),

            ],
          )),
    );
  }
}
