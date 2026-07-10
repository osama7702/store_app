import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';

/// Search input with debounce and a clear button.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.onChanged,
    required this.onClear,
    this.initialValue = '',
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String initialValue;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;
  Timer? _debounce;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _hasText = widget.initialValue.isNotEmpty;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _hasText = value.isNotEmpty);
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () {
      widget.onChanged(value);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    setState(() => _hasText = false);
    widget.onClear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: _clear,
                tooltip: 'Clear',
              )
            : null,
      ),
    );
  }
}
