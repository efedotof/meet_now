import 'package:flutter/material.dart';

class CityForm extends StatelessWidget {
  const CityForm({super.key, required TextEditingController cityName})
    : _cityName = cityName;

  final TextEditingController _cityName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _cityName,
          decoration: const InputDecoration(
            labelText: 'Название города',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
