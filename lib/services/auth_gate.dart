// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../guru_pages/guru_home_pages/guru_home_page.dart';
// import '../ortu_pages/home_pages/home_page.dart';
// import '../widgets/bottom_navbar.dart';
// import '../pages/login_page.dart';
// import '../services/auth_service.dart';
// import 'package:firebase_database/firebase_database.dart';

// class AuthGate extends StatelessWidget {
//   final String role;
//   const AuthGate({super.key, required this.role});

//   @override
//   Widget build(BuildContext context) {
//     final databaseRef = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://lifesync-capstone-default-rtdb.asia-southeast1.firebasedatabase.app/').ref();

//     return StreamBuilder<User?>(
//       stream: AuthService().authStateChange,
//       builder: (context, authSnapshot) {
//         if (authSnapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//               body: Center(child: CircularProgressIndicator()));
//         }

//         final user = authSnapshot.data;
//         if (user != null) {
//           return StreamBuilder<DatabaseEvent>(
//             stream: databaseRef.child('users/${user.uid}').onValue,
//             builder: (context, dbSnapshot) {
//               if (dbSnapshot.connectionState == ConnectionState.waiting) {
//                 return const Scaffold(
//                     body: Center(child: CircularProgressIndicator()));
//               }

//               if (!dbSnapshot.hasData ||
//                   dbSnapshot.data!.snapshot.value == null) {
//                 Future.delayed(const Duration(milliseconds: 500), () {
//                   databaseRef.child('users/${user.uid}').keepSynced(true);
//                 });
//                 return const Scaffold(
//                     body: Center(child: CircularProgressIndicator()));
//               }

//               final userData = Map<String, dynamic>.from(
//                   dbSnapshot.data!.snapshot.value as Map<dynamic, dynamic>);
//               final userRole = userData['role'] as String? ?? '';

//               switch (userRole) {
//                 case "Guru":
//                   return BottomNavbar(role: userRole,);
//                 case "Orang Tua":
//                   // return const BottomNavbar(role: userRole,);
//                   return BottomNavbar(role: userRole,);
//                 default:
//                   return const Scaffold(
//                       body: Center(child: Text("Role tidak dikenali")));
//               }
//             },
//           );
//         } else {
//           return LoginPage(role: role);
//         }
//       },
//     );
//   }
// }