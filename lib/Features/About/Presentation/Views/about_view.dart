import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import '../Widgets/developer_names_widget.dart';


class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> programmers = [
      {"role": "uiUx","name" : const DeveloperNamesWidget(name1:"uiUxDeveloper" ,name2: "",name3: "",), },
      {"role": "mobile","name" : const DeveloperNamesWidget(name1:"mobileDeveloper1" ,name2:"mobileDeveloper2" ,name3: "",),},
      {"role": "backend","name" : const DeveloperNamesWidget(name1: "backendDeveloper1",name2: "backendDeveloper2",name3: "",),},
      {"role": "frontend","name" : const DeveloperNamesWidget(name1:"frontendDeveloper1" ,name2:"frontendDeveloper2" ,name3: "",), },
      {"role": "ai","name" : const DeveloperNamesWidget(name1: "aiDeveloper1",name2: "aiDeveloper2",name3: "aiDeveloper3",),},
    ];

    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
        elevation: 0,
        backgroundColor: myWhiteColor,
        leading:  IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              // size: 20,
              Icons.arrow_back,
              color: primaryColor,
            )),

      )),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetsData.about),
            // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 10),
              child: RegularTextWithLocalization(
                  text:'programmers',
                  fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
            ),
            const Divider(color: bottomColor,),

            Expanded(
              child: ListView.builder(
                itemCount: programmers.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                         Padding(
                           padding: const EdgeInsets.only(top: 12),
                           child: Image.asset(AssetsData.bigDot),
                         ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12,bottom: 3,right: 5),
                            child: RegularTextWithLocalization(
                                text:programmers[index]["role"],
                                 fontSize: 20.sp, textColor: primaryColor, fontFamily: medium),
                          ),
                        ],
                      ),
                      programmers[index]["name"],

                    ],
                  );
                },
              ),
            ),

          ],
        ),
      ),

    );
  }
}


