import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';
import '../state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _rideUpdates = true;
  bool _autoShare = false;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: -0.7,
                  ),
                ),
              ),
              const Pill(
                label: 'GOLD',
                icon: Icons.workspace_premium_rounded,
                background: Color(0xFFFFF1D6),
                foreground: Color(0xFF8A5A00),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'Your profile, payments and preferences.',
            style: TextStyle(fontSize: 12.5, color: AppColors.muted),
          ),
          const SizedBox(height: 18),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const AvatarCircle(
                  initials: 'AS',
                  size: 56,
                  background: AppColors.primarySoft,
                  foreground: AppColors.primaryDark,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        riderName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        riderPhone,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        riderEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _editProfile,
                  tooltip: 'Edit profile',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.bg,
                    foregroundColor: AppColors.inkSoft,
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _GoldCard(onTap: _showGoldBenefits),
          const SizedBox(height: 22),
          const SectionHeader(title: 'Payments'),
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.all(14),
            onTap: () => _showPaymentSheet(state),
            child: Row(
              children: [
                IconBubble(
                  icon: state.payment.icon,
                  size: 42,
                  background: AppColors.bg,
                  foreground: AppColors.primaryDark,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Default payment',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${state.payment.name} • ${state.payment.detail}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _showPaymentSheet(state),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Change'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'Rewards & safety'),
          const SizedBox(height: 10),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuRow(
                  icon: Icons.local_offer_rounded,
                  title: 'Promo codes',
                  subtitle: 'SAWARI50 is active — 50% off',
                  onTap: _showPromos,
                ),
                const Divider(indent: 16, endIndent: 16),
                _MenuRow(
                  icon: Icons.shield_rounded,
                  title: 'Safety toolkit',
                  subtitle: 'Emergency numbers & trip sharing',
                  onTap: _showSafety,
                ),
                const Divider(indent: 16, endIndent: 16),
                _MenuRow(
                  icon: Icons.support_agent_rounded,
                  title: 'Help & support',
                  subtitle: '24/7 support in Urdu and English',
                  onTap: _showHelp,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'Preferences'),
          const SizedBox(height: 10),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ToggleRow(
                  icon: Icons.notifications_active_rounded,
                  title: 'Ride updates',
                  subtitle: 'Driver arrival, PIN and receipts',
                  value: _rideUpdates,
                  onChanged: (value) => setState(() => _rideUpdates = value),
                ),
                const Divider(indent: 16, endIndent: 16),
                _ToggleRow(
                  icon: Icons.family_restroom_rounded,
                  title: 'Auto-share trips',
                  subtitle: 'Share every live trip with family',
                  value: _autoShare,
                  onChanged: (value) => setState(() => _autoShare = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'About'),
          const SizedBox(height: 10),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuRow(
                  icon: Icons.info_rounded,
                  title: 'App version',
                  subtitle: 'Sawari 1.0.0 • Flutter',
                  trailing: const Text(
                    'Latest',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () => showSnack(
                    context,
                    'You are on the latest version of Sawari.',
                    icon: Icons.check_circle_rounded,
                  ),
                ),
                const Divider(indent: 16, endIndent: 16),
                _MenuRow(
                  icon: Icons.description_outlined,
                  title: 'Terms & privacy',
                  subtitle: 'How Sawari protects your data',
                  onTap: () => showSnack(
                    context,
                    'Terms and privacy policy open in the help centre.',
                    icon: Icons.open_in_new_rounded,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _signOut,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: BorderSide(
                color: AppColors.danger.withValues(alpha: .3),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Sign out'),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              'Sawari • Made with pride in Pakistan',
              style: TextStyle(
                fontSize: 10.5,
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile() async {
    var name = riderName;
    var phone = riderPhone;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Edit profile',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: riderName,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) => name = value,
                decoration: const InputDecoration(labelText: 'Full name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: riderPhone,
                keyboardType: TextInputType.phone,
                onChanged: (value) => phone = value,
                decoration: const InputDecoration(labelText: 'Phone number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (saved == true && mounted) {
      final trimmed = name.trim();
      showSnack(
        context,
        trimmed.isEmpty || phone.trim().isEmpty
            ? 'Profile updated for this demo session.'
            : 'Profile updated for $trimmed.',
        icon: Icons.check_circle_rounded,
      );
    }
  }

  void _showPaymentSheet(AppState state) {
    showSawariSheet(
      context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment methods',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 3),
              const Text(
                'Your selected method is used for every new booking.',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              for (final method in paymentMethods) ...[
                Material(
                  color: method.id == state.payment.id
                      ? AppColors.primarySoft
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      state.payment = method;
                      Navigator.of(sheetContext).pop();
                      showSnack(
                        context,
                        '${method.name} set as default payment.',
                        icon: Icons.check_circle_rounded,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: method.id == state.payment.id
                              ? AppColors.primary.withValues(alpha: .4)
                              : AppColors.line,
                        ),
                      ),
                      child: Row(
                        children: [
                          IconBubble(
                            icon: method.icon,
                            size: 38,
                            background: method.id == state.payment.id
                                ? Colors.white
                                : AppColors.bg,
                            foreground: AppColors.primaryDark,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method.name,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                  ),
                                ),
                                Text(
                                  method.detail,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            method.id == state.payment.id
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            color: method.id == state.payment.id
                                ? AppColors.primary
                                : AppColors.muted,
                            size: 21,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showPromos() {
    showSawariSheet(
      context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Promo codes',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 3),
              const Text(
                'Copy a code and apply it at checkout.',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: .25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '50% off your next 3 rides',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(
                                const ClipboardData(text: 'SAWARI50'),
                              );
                              Navigator.of(sheetContext).pop();
                              showSnack(
                                context,
                                'Code SAWARI50 copied',
                                icon: Icons.copy_rounded,
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'SAWARI50',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: .8,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(
                                    Icons.copy_rounded,
                                    size: 13,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Valid on Bike, Rickshaw, Mini and Comfort rides. '
                      'Discount up to Rs 300.',
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppColors.primaryDark.withValues(alpha: .75),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const _InfoTile(
                icon: Icons.workspace_premium_rounded,
                text: 'Gold members earn 5% cashback on every ride — no code needed.',
              ),
              const SizedBox(height: 8),
              const _InfoTile(
                icon: Icons.event_repeat_rounded,
                text: 'New offers drop every Friday across all cities.',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSafety() {
    showSawariSheet(
      context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Safety toolkit',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 3),
              const Text(
                'Emergency helplines across Pakistan.',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              _EmergencyRow(title: 'Police helpline', number: '15'),
              const SizedBox(height: 8),
              _EmergencyRow(title: 'Rescue 1122', number: '1122'),
              const SizedBox(height: 8),
              _EmergencyRow(title: 'Motorway Police', number: '130'),
              const SizedBox(height: 16),
              const _InfoTile(
                icon: Icons.share_location_rounded,
                text: 'Share any live trip from the ride screen. Your family '
                    'sees the driver, vehicle and route in real time.',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelp() {
    showSawariSheet(
      context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help & support',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 3),
              const Text(
                'We are here 24/7, in Urdu and English.',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              _MenuRow(
                icon: Icons.call_rounded,
                title: 'Call support',
                subtitle: '0800 724 000 — free from landlines',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  showSnack(context, 'Connecting you to Sawari support…',
                      icon: Icons.call_rounded);
                },
              ),
              const SizedBox(height: 8),
              _MenuRow(
                icon: Icons.chat_rounded,
                title: 'WhatsApp',
                subtitle: '+92 300 111 2233',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  showSnack(context, 'Opening WhatsApp chat with support…',
                      icon: Icons.chat_rounded);
                },
              ),
              const SizedBox(height: 8),
              _MenuRow(
                icon: Icons.mail_outline_rounded,
                title: 'Email',
                subtitle: 'help@sawari.pk',
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  showSnack(context, 'Opening email to help@sawari.pk…',
                      icon: Icons.mail_outline_rounded);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGoldBenefits() {
    showSawariSheet(
      context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const IconBubble(
                    icon: Icons.workspace_premium_rounded,
                    size: 44,
                    background: Color(0xFFFFF1D6),
                    foreground: Color(0xFF8A5A00),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sawari Gold',
                      style: Theme.of(sheetContext).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _BenefitRow(
                icon: Icons.bolt_rounded,
                title: 'Priority pickups',
                message: 'Matched with the nearest driver first.',
              ),
              const SizedBox(height: 12),
              const _BenefitRow(
                icon: Icons.savings_rounded,
                title: '5% cashback',
                message: 'Credited to your wallet after every ride.',
              ),
              const SizedBox(height: 12),
              const _BenefitRow(
                icon: Icons.event_busy_rounded,
                title: 'Free cancellations',
                message: 'Change of plan? Cancel without a fee.',
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Sign out of Sawari?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text('You can sign back in with $riderPhone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Stay signed in'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
              child: const Text('Sign out'),
            ),
          ],
        );
      },
    );
    if (confirmed == true && mounted) {
      showSnack(
        context,
        'Signed out of the demo account.',
        icon: Icons.logout_rounded,
      );
    }
  }
}

class _GoldCard extends StatelessWidget {
  const _GoldCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryDark,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              right: -24,
              top: -34,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sawari Gold member',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Priority pickups & 5% cashback',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.white.withValues(alpha: .7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            IconBubble(
              icon: icon,
              size: 38,
              background: AppColors.bg,
              foreground: AppColors.primaryDark,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColors.muted,
                ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          IconBubble(
            icon: icon,
            size: 38,
            background: AppColors.bg,
            foreground: AppColors.primaryDark,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _EmergencyRow extends StatelessWidget {
  const _EmergencyRow({required this.title, required this.number});

  final String title;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emergency_rounded,
            size: 20,
            color: AppColors.danger,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          Text(
            number,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.inkSoft,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconBubble(
          icon: icon,
          size: 36,
          background: AppColors.primarySoft,
          foreground: AppColors.primary,
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.inkSoft,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
