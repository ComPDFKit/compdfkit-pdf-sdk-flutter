// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

part of '../certificate_management_example.dart';

/// Shared presentation models and reusable controls for certificate pages.
class _CertificateSession {
  const _CertificateSession({
    required this.path,
    required this.password,
    this.generated = false,
  });

  final String path;
  final String password;
  final bool generated;

  String get name => path.split(Platform.pathSeparator).last;
}

class _CertificateAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _CertificateAppBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: false,
        child: AppToolbar(
          title: title,
          onBack: () => Navigator.of(context).maybePop(),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

abstract final class _CertificateText {
  static const _font = 'Inter';
  static const section = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w600,
    color: _CertificateTheme.text,
  );
  static const sectionDescription = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    height: 1.25,
    color: _CertificateTheme.muted,
  );
  static const body = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    height: 1.4,
    color: _CertificateTheme.muted,
  );
  static const actionTitle = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    height: 1.25,
    fontWeight: FontWeight.w600,
    color: _CertificateTheme.text,
  );
  static const label = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: _CertificateTheme.text,
  );
  static const groupHeading = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    height: 1.25,
    fontWeight: FontWeight.w600,
    color: Color(0xFF465062),
  );
  static const input = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    height: 1.2,
    color: _CertificateTheme.text,
  );
  static const tag = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: _CertificateTheme.primary,
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.description,
  });

  final String title;
  final String? description;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _CertificateText.section),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(description!, style: _CertificateText.sectionDescription),
          ],
        ],
      );
}

class _SourceAction extends StatelessWidget {
  const _SourceAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => _PencilPanel(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 20, color: _CertificateTheme.primary),
                const SizedBox(height: 8),
                Text(title, style: _CertificateText.actionTitle),
                const SizedBox(height: 2),
                Text(subtitle, style: _CertificateText.body),
              ],
            ),
          ),
        ),
      );
}

class _CurrentCertificateCard extends StatelessWidget {
  const _CurrentCertificateCard({
    required this.session,
    required this.verified,
    required this.certificate,
  });

  final _CertificateSession? session;
  final bool verified;
  final CPDFCertificateInfo? certificate;

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const _PencilPanel(
        padding: EdgeInsets.all(16),
        child: Row(children: [
          _CertificateIconTile(icon: Icons.key_outlined),
          SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('No certificate selected',
                  style: _CertificateText.actionTitle),
              SizedBox(height: 3),
              Text('Generate a test certificate or choose an existing file.',
                  style: _CertificateText.body),
            ],
          )),
        ]),
      );
    }
    return _PencilPanel(
      padding: const EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _CertificateIconTile(icon: Icons.verified_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session!.name, style: _CertificateText.actionTitle),
                      Text(session!.path,
                          style: _CertificateText.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                const _CertificateTag(
                  label: 'Loaded',
                  backgroundColor: _CertificateTheme.softBlue,
                  foregroundColor: _CertificateTheme.primary,
                ),
                if (verified)
                  const _CertificateTag(
                    label: 'Verified',
                    backgroundColor: _CertificateTheme.softGreen,
                    foregroundColor: Color(0xFF16A34A),
                  ),
                if (certificate?.isTrusted == true)
                  const _CertificateTag(
                    label: 'Trusted',
                    backgroundColor: _CertificateTheme.softGreen,
                    foregroundColor: Color(0xFF16A34A),
                  ),
                if (session!.generated)
                  const _CertificateTag(
                    label: 'Generated',
                    backgroundColor: Color(0xFFF5F7FA),
                    foregroundColor: _CertificateTheme.muted,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionList extends StatelessWidget {
  const _ActionList({
    required this.enabled,
    required this.detailsEnabled,
    required this.onUnlock,
    required this.onDetails,
    required this.onTrust,
  });

  final bool enabled;
  final bool detailsEnabled;
  final VoidCallback onUnlock;
  final VoidCallback onDetails;
  final VoidCallback? onTrust;

  @override
  Widget build(BuildContext context) => _PencilPanel(
        child: Column(
          children: [
            _ActionTile(
              title: 'Unlock certificate',
              subtitle: 'Verify the certificate password before continuing.',
              enabled: enabled,
              onTap: onUnlock,
            ),
            const Divider(height: 1, color: _CertificateTheme.border),
            _ActionTile(
              title: 'View certificate details',
              subtitle: 'Review issuer, validity and fingerprints.',
              enabled: detailsEnabled,
              onTap: onDetails,
            ),
            const Divider(height: 1, color: _CertificateTheme.border),
            _ActionTile(
              title: 'Add to trusted certificates',
              subtitle: 'Allow this certificate for signature verification.',
              enabled: onTrust != null,
              onTap: onTrust,
            ),
          ],
        ),
      );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: enabled ? 1 : .45,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
            child: Row(children: [
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _CertificateText.actionTitle),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: _CertificateText.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              )),
              const Icon(Icons.chevron_right,
                  size: 20, color: _CertificateTheme.muted),
            ]),
          ),
        ),
      );
}

class _PlatformStorageCard extends StatelessWidget {
  const _PlatformStorageCard();

  @override
  Widget build(BuildContext context) => const _InfoMessage(
        color: _CertificateTheme.warning,
        icon: Icons.info_outline,
        iconColor: Color(0xFFC46A00),
        title: 'SDK-managed certificate storage',
        text:
            'Certificates are stored in the application sandbox. Custom certificate directories are not supported.',
      );
}
