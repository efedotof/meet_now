import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/server/model/city/city.dart';

class PersonalInfoPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;
  final double buttonWidth;
  const PersonalInfoPage({
    super.key,
    required this.formKey,
    required this.formData,
    required this.buttonWidth,
  });

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();
  List<City> _foundCities = [];
  bool _isSearching = false;
  bool _showDropdown = false;
  bool _citySelected = false;

  // Добавляем ScrollController для управления прокруткой
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cityController.text = widget.formData.city;
    _cityFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_cityFocusNode.hasFocus && _cityController.text.length >= 2 && !_citySelected) {
      setState(() {
        _showDropdown = true;
      });
      // Прокручиваем к полю города при фокусе
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } else if (!_cityFocusNode.hasFocus) {
      setState(() {
        _showDropdown = false;
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _cityFocusNode.removeListener(_handleFocusChange);
    _cityFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onCitySelected(City city) {
    setState(() {
      _cityController.text = city.nameCity;
      widget.formData.city = city.nameCity;
      _showDropdown = false;
      _citySelected = true;
    });
    _cityFocusNode.unfocus();
  }

  Future<void> _searchCities(String query) async {
    if (query.length < 2) {
      setState(() {
        _foundCities = [];
        _isSearching = false;
        _showDropdown = false;
        _citySelected = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showDropdown = true;
      _citySelected = false;
    });

    final cities = await context.read<SignUpCubit>().searchCities(query);

    if (mounted) {
      setState(() {
        _foundCities = cities;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          controller: _scrollController, // Добавляем контроллер прокрутки
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showDropdown
                    ? const SizedBox()
                    : Text(
                        S.of(context).personalInfo,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[800],
                            ),
                      ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: _showDropdown
                    ? Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: widget.buttonWidth),
                            child: TextFormField(
                              controller: _cityController,
                              focusNode: _cityFocusNode,
                              autofocus: true, // Автоматически фокусируемся на поле
                              decoration: InputDecoration(
                                labelText: 'Город',
                                hintText: 'Начните вводить название города',
                                prefixIcon: const Icon(Icons.location_city_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              onChanged: _searchCities,
                              validator: (value) => value!.isEmpty ? 'Введите город' : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _showDropdown
                                ? Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      constraints: const BoxConstraints(maxHeight: 200),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: _isSearching
                                          ? const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(16),
                                                child: CircularProgressIndicator(),
                                              ),
                                            )
                                          : _foundCities.isEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Text(
                                                    'Города не найдены',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: _foundCities.length,
                                                  itemBuilder: (context, index) {
                                                    final city = _foundCities[index];
                                                    return ListTile(
                                                      leading: const Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                      title: Text(
                                                        city.nameCity,
                                                        style: const TextStyle(fontSize: 16),
                                                      ),
                                                      onTap: () => _onCitySelected(city),
                                                    );
                                                  },
                                                ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          const SizedBox(height: 16),
                          _buildFirstNameField(context),
                          const SizedBox(height: 16),
                          _buildLastNameField(context),
                          const SizedBox(height: 16),
                          _buildAgeField(context),
                        ],
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildFirstNameField(context),
                          const SizedBox(height: 16),
                          _buildLastNameField(context),
                          const SizedBox(height: 16),
                          _buildAgeField(context),
                          const SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: widget.buttonWidth),
                            child: TextFormField(
                              controller: _cityController,
                              focusNode: _cityFocusNode,
                              decoration: InputDecoration(
                                labelText: 'Город',
                                hintText: 'Начните вводить название города',
                                prefixIcon: const Icon(Icons.location_city_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              onChanged: _searchCities,
                              validator: (value) => value!.isEmpty ? 'Введите город' : null,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameField(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.buttonWidth),
      child: TextFormField(
        initialValue: widget.formData.firstname,
        decoration: InputDecoration(
          labelText: S.of(context).firstName,
          prefixIcon: const Icon(Icons.person_outline),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (value) => value!.isEmpty ? S.of(context).enterFirstName : null,
        onChanged: (value) => widget.formData.firstname = value,
      ),
    );
  }

  Widget _buildLastNameField(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.buttonWidth),
      child: TextFormField(
        initialValue: widget.formData.subname,
        decoration: InputDecoration(
          labelText: S.of(context).lastName,
          prefixIcon: const Icon(Icons.person_outline),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (value) => value!.isEmpty ? S.of(context).enterLastName : null,
        onChanged: (value) => widget.formData.subname = value,
      ),
    );
  }

  Widget _buildAgeField(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.buttonWidth),
      child: TextFormField(
        initialValue: widget.formData.age > 0 ? widget.formData.age.toString() : '',
        decoration: InputDecoration(
          labelText: S.of(context).age,
          prefixIcon: const Icon(Icons.cake_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) return S.of(context).enterAge;
          final age = int.tryParse(value);
          if (age == null || age < 14) return S.of(context).minAge;
          return null;
        },
        onChanged: (value) => widget.formData.age = int.tryParse(value) ?? 0,
      ),
    );
  }
}