import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/city/city.dart';

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
  City? _selectedCity;
  final GlobalKey _cityFieldKey = GlobalKey();
  String? _cityErrorText;

  @override
  void initState() {
    super.initState();
    _cityController.text = widget.formData.city;
    _cityFocusNode.addListener(_handleFocusChange);
    widget.formData.city = '';
  }

  void _handleFocusChange() {
    if (_cityFocusNode.hasFocus &&
        _cityController.text.length >= 2 &&
        !_citySelected) {
      setState(() => _showDropdown = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = _cityFieldKey.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else if (!_cityFocusNode.hasFocus) {
      setState(() => _showDropdown = false);
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _cityFocusNode.removeListener(_handleFocusChange);
    _cityFocusNode.dispose();
    super.dispose();
  }

  void _onCitySelected(City city) {
    setState(() {
      _cityController.text = city.nameCity;
      _selectedCity = city;
      widget.formData.city = city.nameCity;
      _showDropdown = false;
      _citySelected = true;
      _cityErrorText = null;
    });
    _cityFocusNode.unfocus();

    if (widget.formKey.currentState != null) {
      widget.formKey.currentState!.validate();
    }
  }

  Future<void> _searchCities(String query) async {
    if (query.length < 2) {
      setState(() {
        _foundCities = [];
        _isSearching = false;
        _showDropdown = false;
        _citySelected = false;
        _selectedCity = null;
        widget.formData.city = '';
        _cityErrorText = null;
      });
      return;
    }

    if (_selectedCity != null &&
        _cityController.text != _selectedCity!.nameCity) {
      setState(() {
        _citySelected = false;
        _selectedCity = null;
        widget.formData.city = '';
        _cityErrorText = null;
      });
    }

    setState(() {
      _isSearching = true;
      _showDropdown = true;
    });

    final cities = await context.read<SignUpCubit>().searchCities(query);

    if (mounted) {
      setState(() {
        _foundCities = cities;
        _isSearching = false;
      });
    }
  }

  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enter_the_city;
    }

    if (!_citySelected) {
      return S.of(context).please_select_city_from_list;
    }

    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enterAge;
    }

    final age = int.tryParse(value);
    if (age == null) {
      return S.of(context).enter_valid_age;
    }

    if (age < 18) {
      return S.of(context).min_age_18;
    }

    if (age > 65) {
      return S.of(context).max_age_65;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = theme.colorScheme.onSurface;
    final errorColor = theme.colorScheme.error;
    final dropdownTextColor = isDark ? Colors.white : Colors.black;

    final fieldBackgroundColor =
        isDark
            ? theme.colorScheme.surfaceContainerHighest.withAlpha(50)
            : Colors.grey[50];

    final dropdownBackgroundColor =
        isDark ? theme.colorScheme.surfaceContainerHighest : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).personalInfo,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.buttonWidth),
                child: TextFormField(
                  key: _cityFieldKey,
                  controller: _cityController,
                  focusNode: _cityFocusNode,
                  readOnly: _citySelected,
                  decoration: InputDecoration(
                    labelText: S.of(context).city,

                    hintText: S.of(context).start_entering_the_name_of_the_city,

                    prefixIcon: Icon(Icons.location_city_outlined),
                    suffixIcon:
                        _citySelected
                            ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _cityController.clear();
                                  _citySelected = false;
                                  _selectedCity = null;
                                  widget.formData.city = '';
                                  _showDropdown = false;
                                  _foundCities.clear();
                                });
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withAlpha(50),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: errorColor),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: errorColor, width: 2),
                    ),
                    filled: true,
                    fillColor: fieldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    errorText: _cityErrorText,
                  ),
                  style: TextStyle(color: textColor),
                  onChanged: _searchCities,
                  validator: _validateCity,
                ),
              ),
              if (_showDropdown) ...[
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: dropdownBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withAlpha(30),
                        ),
                      ),
                      child:
                          _isSearching
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
                                  S.of(context).cities_not_found,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(60),
                                  ),
                                ),
                              )
                              : ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: _foundCities.length,
                                itemBuilder: (context, index) {
                                  final city = _foundCities[index];
                                  return ListTile(
                                    leading: Icon(
                                      Icons.location_on,
                                      color: theme.colorScheme.primary,
                                    ),
                                    title: Text(
                                      city.nameCity,
                                      style: TextStyle(
                                        color: dropdownTextColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    onTap: () => _onCitySelected(city),
                                  );
                                },
                              ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.buttonWidth),
                child: TextFormField(
                  initialValue: widget.formData.firstname,
                  decoration: InputDecoration(
                    labelText: S.of(context).firstName,

                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withAlpha(50),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: errorColor),
                    ),
                    filled: true,
                    fillColor: fieldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  validator:
                      (value) =>
                          value!.isEmpty ? S.of(context).enterFirstName : null,
                  onChanged: (value) => widget.formData.firstname = value,
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.buttonWidth),
                child: TextFormField(
                  initialValue: widget.formData.subname,
                  decoration: InputDecoration(
                    labelText: S.of(context).lastName,

                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withAlpha(50),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: errorColor),
                    ),
                    filled: true,
                    fillColor: fieldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  validator:
                      (value) =>
                          value!.isEmpty ? S.of(context).enterLastName : null,
                  onChanged: (value) => widget.formData.subname = value,
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.buttonWidth),
                child: TextFormField(
                  initialValue:
                      widget.formData.age > 0
                          ? widget.formData.age.toString()
                          : '',
                  decoration: InputDecoration(
                    labelText: S.of(context).age,

                    prefixIcon: Icon(Icons.cake_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withAlpha(50),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: errorColor),
                    ),
                    filled: true,
                    fillColor: fieldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                  validator: _validateAge,
                  onChanged: (value) {
                    final age = int.tryParse(value) ?? 0;
                    widget.formData.age = age;
                    if (widget.formKey.currentState != null) {
                      widget.formKey.currentState!.validate();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
