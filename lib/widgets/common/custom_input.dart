import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/app_theme.dart';
import 'custom_text.dart';

enum InputType { text, email, password, search, multiline }

class CustomInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final InputType type;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final String? initialValue;

  const CustomInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.type = InputType.text,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.maxLength,
    this.inputFormatters,
    this.textInputAction,
    this.autofocus = false,
    this.initialValue,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          CustomText(
            widget.label!,
            type: TextType.labelMedium,
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isFocused ? [
              BoxShadow(
                color: AppColors.primaryPink.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            initialValue: widget.initialValue,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            obscureText: widget.type == InputType.password ? _obscureText : false,
            keyboardType: _getKeyboardType(),
            textInputAction: widget.textInputAction ?? _getTextInputAction(),
            maxLines: widget.type == InputType.multiline ? (widget.maxLines ?? 4) : 1,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              helperText: widget.helperText,
              errorText: widget.errorText,
              prefixIcon: widget.prefixIcon != null 
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: widget.prefixIcon,
                    )
                  : _getPrefixIcon(),
              suffixIcon: widget.suffixIcon ?? _getSuffixIcon(),
              filled: true,
              fillColor: _getFillColor(isDark),
              border: _getBorder(isDark, false),
              enabledBorder: _getBorder(isDark, false),
              focusedBorder: _getBorder(isDark, true),
              errorBorder: _getErrorBorder(isDark),
              focusedErrorBorder: _getErrorBorder(isDark),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: isDark 
                    ? AppColors.creamBackground.withOpacity(0.6)
                    : AppColors.lightText,
              ),
              helperStyle: theme.textTheme.bodySmall?.copyWith(
                color: isDark 
                    ? AppColors.creamBackground.withOpacity(0.7)
                    : AppColors.lightText,
              ),
              errorStyle: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getFillColor(bool isDark) {
    if (!widget.enabled) {
      return isDark 
          ? AppColors.darkSurface.withOpacity(0.5)
          : AppColors.creamBackground.withOpacity(0.5);
    }
    
    if (_isFocused) {
      return isDark ? AppColors.darkSurface : AppColors.white;
    }
    
    return isDark 
        ? AppColors.darkSurface.withOpacity(0.8)
        : AppColors.creamBackground.withOpacity(0.8);
  }

  InputBorder _getBorder(bool isDark, bool isFocused) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isFocused 
            ? AppColors.primaryPink
            : (isDark 
                ? AppColors.creamBackground.withOpacity(0.2)
                : AppColors.lightText.withOpacity(0.3)),
        width: isFocused ? 2 : 1,
      ),
    );
  }

  InputBorder _getErrorBorder(bool isDark) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.red.shade400,
        width: 2,
      ),
    );
  }

  Widget? _getPrefixIcon() {
    switch (widget.type) {
      case InputType.email:
        return Icon(
          Icons.email_outlined,
          color: _isFocused ? AppColors.primaryPink : AppColors.lightText,
        );
      case InputType.password:
        return Icon(
          Icons.lock_outlined,
          color: _isFocused ? AppColors.primaryPink : AppColors.lightText,
        );
      case InputType.search:
        return Icon(
          Icons.search,
          color: _isFocused ? AppColors.primaryPink : AppColors.lightText,
        );
      default:
        return null;
    }
  }

  Widget? _getSuffixIcon() {
    if (widget.type == InputType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: _isFocused ? AppColors.primaryPink : AppColors.lightText,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return null;
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    switch (widget.type) {
      case InputType.search:
        return TextInputAction.search;
      case InputType.multiline:
        return TextInputAction.newline;
      default:
        return TextInputAction.done;
    }
  }
}

// Specific input types for common use cases
class EmailInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? errorText;

  const EmailInput({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInput(
      label: label ?? 'Email',
      hint: hint ?? 'Enter your email address',
      type: InputType.email,
      controller: controller,
      onChanged: onChanged,
      errorText: errorText,
      textInputAction: TextInputAction.next,
    );
  }
}

class PasswordInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? errorText;

  const PasswordInput({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInput(
      label: label ?? 'Password',
      hint: hint ?? 'Enter your password',
      type: InputType.password,
      controller: controller,
      onChanged: onChanged,
      errorText: errorText,
      textInputAction: TextInputAction.done,
    );
  }
}

class SearchInput extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const SearchInput({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInput(
      hint: hint ?? 'Search...',
      type: InputType.search,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
    );
  }
}

class MessageInput extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onSend;

  const MessageInput({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInput(
      hint: hint ?? 'Type your message...',
      type: InputType.multiline,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: 3,
      suffixIcon: IconButton(
        icon: const Icon(
          Icons.send,
          color: AppColors.primaryPink,
        ),
        onPressed: onSend,
      ),
    );
  }
}