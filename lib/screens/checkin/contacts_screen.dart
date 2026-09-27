import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../models/trusted_contact.dart';
import '../../state/checkin_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import '../../l10n/app_localizations.dart';

/// Manage trusted contacts. Numbers are stored locally in this prototype and
/// never leave the device.
class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  Future<void> _add(BuildContext context) async {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final added = await showSafarSheet<bool>(
      context,
      title: 'Add a trusted contact',
      subtitle:
          'Someone who would notice if you did not arrive. Stored on this device '
          'only.',
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => (v == null || v.trim().length < 2)
                  ? 'Enter a name of at least 2 characters'
                  : null,
            ),
            const SizedBox(height: Gap.md),
            TextFormField(
              controller: relationController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Relationship',
                hintText: 'Family, roommate, colleague…',
              ),
            ),
            const SizedBox(height: Gap.md),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                hintText: '+92 300 0000000',
              ),
              validator: (v) {
                final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                if (digits.length < 10) {
                  return 'Enter a full phone number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      footer: Builder(
        builder: (sheetContext) => SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(sheetContext).pop(true);
              }
            },
            child: const Text('Add contact'),
          ),
        ),
      ),
    );

    if (added == true && context.mounted) {
      final name = nameController.text.trim();
      context.read<CheckinProvider>().addContact(
            TrustedContact(
              id: 'tc_${DateTime.now().microsecondsSinceEpoch}',
              name: name,
              relation: relationController.text.trim().isEmpty
                  ? 'Contact'
                  : relationController.text.trim(),
              phone: phoneController.text.trim(),
              isPrimary: !context.read<CheckinProvider>().hasContacts,
            ),
          );
      Toast.show(context, '$name added.', tone: ToastTone.success);
    }

    nameController.dispose();
    relationController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkin = context.watch<CheckinProvider>();
    final gutter = Gap.page(context);

    return Scaffold(
      appBar: AppBar(title: Text(L.of(context).trustedContacts)),
      body: checkin.contacts.isEmpty
          ? EmptyState(
              icon: Icons.person_add_alt_1_outlined,
              title: 'No trusted contacts',
              message:
                  'Add someone you would want to be told if you did not arrive. '
                  'Their number stays on this device.',
              primaryLabel: 'Add your first contact',
              onPrimary: () => _add(context),
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.x4l),
              children: [
                const InfoPanel(
                  text:
                      'Contacts are stored on this device only. Safar '
                      'does not upload your contact list.',
                  icon: Icons.lock_outline_rounded,
                  dense: true,
                ),
                const SizedBox(height: Gap.lg),
                for (final c in checkin.contacts)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.md),
                    child: SafarCard(
                      padding: const EdgeInsets.all(Gap.md),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: context.tokens.surfaceAlt,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              c.initials,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(width: Gap.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        c.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                    if (c.isPrimary) ...[
                                      const SizedBox(width: Gap.sm),
                                      Pill(
                                        label: 'Primary',
                                        color: context.scheme.tertiary,
                                        dense: true,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  '${c.relation} · ${c.maskedPhone}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: context.tokens.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert_rounded, size: 20),
                            onSelected: (value) async {
                              if (value == 'primary') {
                                context
                                    .read<CheckinProvider>()
                                    .makePrimary(c.id);
                                Toast.show(
                                  context,
                                  '${c.name} is now your primary contact.',
                                );
                              } else if (value == 'remove') {
                                final ok = await confirmAction(
                                  context,
                                  title: 'Remove ${c.name}?',
                                  message:
                                      'They will no longer be offered when you '
                                      'start a check-in.',
                                  confirmLabel: 'Remove',
                                  destructive: true,
                                  icon: Icons.person_remove_outlined,
                                );
                                if (ok && context.mounted) {
                                  context
                                      .read<CheckinProvider>()
                                      .removeContact(c.id);
                                  Toast.show(context, '${c.name} removed.');
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              if (!c.isPrimary)
                                const PopupMenuItem(
                                  value: 'primary',
                                  child: Text('Make primary'),
                                ),
                              PopupMenuItem(
                                value: 'remove',
                                child: Text(L.of(context).remove),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: checkin.contacts.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _add(context),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 19),
              label: const Text('Add contact'),
            ),
    );
  }
}
