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
  final AutovalidateMode autovalidateMode;

  const PersonalInfoPage({
    super.key,
    required this.formKey,
    required this.formData,
    required this.buttonWidth,
    this.autovalidateMode = AutovalidateMode.disabled,
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
  City? _selectedCity;
  final GlobalKey _cityFieldKey = GlobalKey();

  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enter_the_city;
    }
    return null;
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enterFirstName;
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enterLastName;
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
  void initState() {
    super.initState();
    if (widget.formData.city.isNotEmpty) {
      _cityController.text = widget.formData.city;
      _selectedCity = City(nameCity: widget.formData.city, id: '');
    }
    _cityFocusNode.addListener(_handleFocusChange);

    _cityFocusNode.addListener(() {
      if (!_cityFocusNode.hasFocus) {
        if (_selectedCity != null && widget.formData.city.isEmpty) {
          widget.formData.city = _selectedCity!.nameCity;
        } else if (_cityController.text.isNotEmpty && _selectedCity == null) {
          widget.formData.city = _cityController.text;
        }
      }
    });
  }

  void _handleFocusChange() {
    if (_cityFocusNode.hasFocus &&
        _cityController.text.length >= 2 &&
        _selectedCity == null) {
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
    });

    if (widget.formKey.currentState != null) {
      widget.formKey.currentState!.validate();
    }

    _cityFocusNode.unfocus();
  }

  Future<void> _searchCities(String query) async {
    if (query.length < 2) {
      setState(() {
        _foundCities = [];
        _isSearching = false;
        _showDropdown = false;
      });
      return;
    }

    widget.formData.city = query;

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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: widget.formKey,
          autovalidateMode: widget.autovalidateMode,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S.of(context).personalInfo,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: widget.buttonWidth),
                  child: TextFormField(
                    key: _cityFieldKey,
                    controller: _cityController,
                    focusNode: _cityFocusNode,
                    readOnly: _selectedCity != null,
                    decoration: InputDecoration(
                      labelText: S.of(context).city,
                      hintText:
                          S.of(context).start_entering_the_name_of_the_city,
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      suffixIcon:
                          _selectedCity != null
                              ? IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _cityController.clear();
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
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline,
                        ),
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
                    ),
                    style: TextStyle(color: textColor),
                    onChanged: _searchCities,
                    validator: _validateCity,
                  ),
                ),
                if (_showDropdown) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: widget.buttonWidth),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: dropdownBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outline.withAlpha(30),
                              ),
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
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
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline,
                        ),
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
                    validator: _validateFirstName,
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
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline,
                        ),
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
                    validator: _validateLastName,
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
                      prefixIcon: const Icon(Icons.cake_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline,
                        ),
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
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
