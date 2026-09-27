import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// Read-only field that looks like an input but opens a picker. Used for the
/// origin/destination slots on the home screen.
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.hint = 'Choose a place',
    this.leading,
    this.leadingColor,
    this.trailing,
    this.dense = false,
  });

  final String label;
  final String? value;
  final String hint;
  final VoidCallback onTap;
  final IconData? leading;
  final Color? leadingColor;
  final Widget? trailing;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final filled = value != null && value!.isNotEmpty;
    final t = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '$label. ${filled ? value! : hint}',
      child: InkWell(
        onTap: onTap,
        borderRadius: Radii.allMd,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Gap.md,
            vertical: dense ? Gap.sm : Gap.md - 1,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                Icon(
                  leading,
                  size: 17,
                  color: leadingColor ?? context.tokens.textTertiary,
                ),
                const SizedBox(width: Gap.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: t.labelSmall
                          ?.copyWith(color: context.tokens.textTertiary),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      filled ? value! : hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleMedium?.copyWith(
                        color: filled
                            ? context.tokens.textPrimary
                            : context.tokens.textTertiary,
                        fontWeight:
                            filled ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// The app's search bar. Used on the destination picker and the explore screen.
class SafarSearchField extends StatelessWidget {
  const SafarSearchField({
    super.key,
    required this.controller,
    this.hint = 'Search Bahawalpur',
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.leading,
    this.onLeadingTap,
    this.trailing,
    this.focusNode,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final IconData? leading;
  final VoidCallback? onLeadingTap;
  final Widget? trailing;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          textInputAction: TextInputAction.search,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: leading == null
                ? const Icon(Icons.search_rounded, size: 20)
                : IconButton(
                    icon: Icon(leading, size: 20),
                    onPressed: onLeadingTap,
                  ),
            prefixIconConstraints: const BoxConstraints(minWidth: 46),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    tooltip: L.of(context).clear,
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      controller.clear();
                      onChanged?.call('');
                    },
                  )
                : trailing,
            contentPadding: const EdgeInsets.symmetric(vertical: Gap.md + 2),
          ),
        );
      },
    );
  }
}

/// Segmented selector used for durations, languages and demo personas.
class SegmentedSelector<T> extends StatelessWidget {
  const SegmentedSelector({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.scrollable = false,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        for (final v in values)
          Expanded(
            flex: scrollable ? 0 : 1,
            child: _segment(context, v),
          ),
      ],
    );

    final wrapped = Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.tokens.isDark
            ? context.tokens.surfaceAlt
            : const Color(0xFFEDF0F5),
        borderRadius: Radii.allMd,
      ),
      child: row,
    );

    if (!scrollable) return wrapped;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: wrapped,
    );
  }

  Widget _segment(BuildContext context, T v) {
    final isSelected = v == selected;
    return GestureDetector(
      onTap: () => onChanged(v),
      child: AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.enter,
        padding: const EdgeInsets.symmetric(
          horizontal: Gap.md,
          vertical: Gap.sm + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.scheme.surface : Colors.transparent,
          borderRadius: Radii.allSm,
          boxShadow: isSelected ? context.tokens.cardShadow : null,
        ),
        alignment: Alignment.center,
        child: Text(
          labelOf(v),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Jakarta',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? context.scheme.primary
                : context.tokens.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// A row in the settings screen. Supports switch, value and navigation forms.
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.value,
    this.switchValue,
    this.onSwitch,
    this.onTap,
    this.tone,
    this.trailing,
    this.destructive = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? value;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitch;
  final VoidCallback? onTap;
  final Color? tone;
  final Widget? trailing;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final accent = destructive
        ? context.scheme.error
        : tone ?? context.scheme.primary;

    return InkWell(
      onTap: onSwitch != null && onTap == null
          ? () => onSwitch!(!(switchValue ?? false))
          : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Gap.lg,
          vertical: Gap.md + 2,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: context.isDark ? 0.2 : 0.09),
                  borderRadius: Radii.allSm,
                ),
                child: Icon(icon, size: 17, color: accent),
              ),
              const SizedBox(width: Gap.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: t.titleMedium?.copyWith(
                      color: destructive
                          ? context.scheme.error
                          : context.tokens.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: t.bodySmall
                          ?.copyWith(color: context.tokens.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Gap.md),
            if (trailing != null)
              trailing!
            else if (switchValue != null)
              Switch(value: switchValue!, onChanged: onSwitch)
            else if (value != null)
              Row(
                children: [
                  Text(
                    value!,
                    style: t.titleSmall
                        ?.copyWith(color: context.tokens.textSecondary),
                  ),
                  if (onTap != null) ...[
                    const SizedBox(width: Gap.xs),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: context.tokens.textTertiary,
                    ),
                  ],
                ],
              )
            else if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: context.tokens.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Groups setting rows into a card with hairline dividers.
class SettingGroup extends StatelessWidget {
  const SettingGroup({super.key, required this.children, this.title});

  final List<Widget> children;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: Gap.xs, bottom: Gap.sm),
            child: Text(
              title!.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: context.scheme.surface,
            borderRadius: Radii.allLg,
            border: Border.all(color: context.tokens.border),
          ),
          child: ClipRRect(
            borderRadius: Radii.allLg,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1)
                    Divider(
                      height: 1,
                      indent: Gap.lg,
                      endIndent: Gap.lg,
                      color: context.tokens.border,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
