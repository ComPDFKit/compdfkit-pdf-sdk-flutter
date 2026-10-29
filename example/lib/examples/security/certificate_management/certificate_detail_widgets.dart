// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

part of '../certificate_management_example.dart';

/// Certificate detail widgets shared by the details page.
class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.label,
    required this.value,
    required this.copyable,
  });

  final String label;
  final String value;
  final bool copyable;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 104, child: Text(label, style: _CertificateText.body)),
          Expanded(child: Text(value, style: _CertificateText.input)),
          if (copyable)
            SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                tooltip: 'Copy',
                padding: EdgeInsets.zero,
                iconSize: 15,
                onPressed: () => Clipboard.setData(ClipboardData(text: value)),
                icon: const Icon(Icons.copy_outlined),
              ),
            ),
        ]),
      );
}

class _InfoMessage extends StatelessWidget {
  const _InfoMessage({
    required this.text,
    this.color = _CertificateTheme.information,
    this.icon = Icons.info_outline,
    this.iconColor = _CertificateTheme.primary,
    this.title,
  });

  final String text;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final String? title;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                if (title != null) ...[
                  Text(title!, style: _CertificateText.actionTitle),
                  const SizedBox(height: 3),
                ],
                Text(text, style: _CertificateText.body),
              ])),
        ]),
      );
}

class _InlineNote extends StatelessWidget {
  const _InlineNote({
    required this.text,
    this.icon = Icons.info_outline,
  });

  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(children: [
          Icon(icon, size: 18, color: _CertificateTheme.muted),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: _CertificateText.body)),
        ]),
      );
}

class _MetadataHeader extends StatelessWidget {
  const _MetadataHeader();

  @override
  Widget build(BuildContext context) => Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE8ECF1))),
        ),
        child: const Row(children: [
          Icon(Icons.expand_less, size: 18, color: _CertificateTheme.muted),
          SizedBox(width: 8),
          Text('Certificate details', style: _CertificateText.actionTitle),
        ]),
      );
}

class _PencilPanel extends StatelessWidget {
  const _PencilPanel({
    required this.child,
    this.padding,
    this.clipBehavior = Clip.none,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) => Container(
        clipBehavior: clipBehavior,
        padding: padding,
        decoration: BoxDecoration(
          color: _CertificateTheme.surface,
          border: Border.all(color: const Color(0xFFE8ECF1)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      );
}

class _CertificateIconTile extends StatelessWidget {
  const _CertificateIconTile({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3F7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: _CertificateTheme.primary),
      );
}

class _CertificateTag extends StatelessWidget {
  const _CertificateTag({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(4)),
        child: SizedBox(
          height: 24,
          child: Center(
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                style: _CertificateText.tag.copyWith(
                    color: foregroundColor, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      );
}

class _TrustedCertificateState extends StatelessWidget {
  const _TrustedCertificateState();

  @override
  Widget build(BuildContext context) => Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _CertificateTheme.softGreen,
          borderRadius: BorderRadius.circular(6),
        ),
        child:
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.verified_outlined, size: 18, color: Color(0xFF16A34A)),
          SizedBox(width: 8),
          Text('Trusted certificate',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF16A34A))),
        ]),
      );
}

class _CertificateDetailsSummary extends StatelessWidget {
  const _CertificateDetailsSummary({
    required this.session,
    required this.certificate,
    required this.onChangeCertificate,
  });

  final _CertificateSession session;
  final CPDFCertificateInfo certificate;
  final VoidCallback onChangeCertificate;

  @override
  Widget build(BuildContext context) => _PencilPanel(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.verified_outlined,
                  size: 18, color: _CertificateTheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.name,
                          style: _CertificateText.actionTitle
                              .copyWith(fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(session.path,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _CertificateText.body.copyWith(fontSize: 10)),
                    ]),
              ),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              const _CertificateTag(
                label: 'Loaded',
                backgroundColor: _CertificateTheme.softBlue,
                foregroundColor: _CertificateTheme.primary,
              ),
              const _CertificateTag(
                label: 'Verified',
                backgroundColor: _CertificateTheme.softGreen,
                foregroundColor: Color(0xFF16A34A),
              ),
              if (certificate.isTrusted)
                const _CertificateTag(
                  label: 'Trusted',
                  backgroundColor: _CertificateTheme.softGreen,
                  foregroundColor: Color(0xFF16A34A),
                ),
              if (session.generated)
                const _CertificateTag(
                  label: 'Generated',
                  backgroundColor: Color(0xFFF5F7FA),
                  foregroundColor: _CertificateTheme.muted,
                ),
            ]),
            const SizedBox(height: 8),
            SizedBox(
              height: 30,
              child: OutlinedButton.icon(
                onPressed: onChangeCertificate,
                icon: const Icon(Icons.swap_horiz, size: 14),
                label: Text('Change certificate', style: _CertificateText.tag),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  side: const BorderSide(color: Color(0xFFE8ECF1)),
                  backgroundColor: const Color(0xFFF8FAFC),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ],
        ),
      );
}
