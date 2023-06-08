// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:tab_bar/models/detail.dart';

// class DetailPage extends StatelessWidget {
//   const DetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Future<List<Detail>> getDetail() async {
//       String jsonString =
//           await rootBundle.loadString('assets/data/detail.json');
//       final jsonResponse = json.decode(jsonString);
//       final details = Detail.fromJson(jsonResponse);
//       //return details.data;
//     }

//     return FutureBuilder<List<Detail>>(
//       future: getDetail(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: const BouncingScrollPhysics(),
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final contact = snapshot.data![index];
//               return Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
//                 child: Card(
//                   color: Colors.white,
//                   surfaceTintColor: Colors.white,
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Row(
//                     children: [
                     
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
                         
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         } else if (snapshot.hasError) {
//           return Center(child: Text(snapshot.error.toString()));
//         }
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }
