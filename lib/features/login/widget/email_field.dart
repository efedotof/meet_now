// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meet_now_admin_panel/features/login/cubit/login_cubit.dart';

// class EmailField extends StatelessWidget {
//   const EmailField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginCubit, LoginState>(
//       buildWhen: (previous, current) =>
//           previous.email != current.email ||
//           previous.emailError != current.emailError,
//       builder: (context, state) {
//         return TextField(
//           onChanged: context.read<LoginCubit>().updateEmail,
//           decoration: InputDecoration(
//             labelText: 'Developer Email',
//             prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[400]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.blue[500]!, width: 2),
//             ),
//             errorText: state.emailError,
//             errorStyle: const TextStyle(fontSize: 12),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 16,
//             ),
//           ),
//           keyboardType: TextInputType.emailAddress,
//           textInputAction: TextInputAction.next,
//           style: TextStyle(fontSize: 16, color: Colors.grey[800]),
//         );
//       },
//     );
//   }
// }
