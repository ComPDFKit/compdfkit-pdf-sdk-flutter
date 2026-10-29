// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION AND DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

part of 'digital_signature_widgets.dart';

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _text,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Close',
          onPressed: onClose,
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(
          color: _text,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );
}

class _SignatureAppearanceEditor extends StatelessWidget {
  const _SignatureAppearanceEditor({
    required this.textController,
    required this.contentController,
    required this.textColor,
    required this.contentColor,
    required this.logoPath,
    required this.imagePath,
    required this.drawLogo,
    required this.drawOnlyContent,
    required this.contentAlignLeft,
    required this.onTextColorChanged,
    required this.onContentColorChanged,
    required this.onLogoChanged,
    required this.onImageChanged,
    required this.onDrawLogoChanged,
    required this.onDrawOnlyContentChanged,
    required this.onContentAlignLeftChanged,
  });

  final TextEditingController textController;
  final TextEditingController contentController;
  final Color textColor;
  final Color contentColor;
  final String? logoPath;
  final String? imagePath;
  final bool drawLogo;
  final bool drawOnlyContent;
  final bool contentAlignLeft;
  final ValueChanged<Color> onTextColorChanged;
  final ValueChanged<Color> onContentColorChanged;
  final ValueChanged<String?> onLogoChanged;
  final ValueChanged<String?> onImageChanged;
  final ValueChanged<bool> onDrawLogoChanged;
  final ValueChanged<bool> onDrawOnlyContentChanged;
  final ValueChanged<bool> onContentAlignLeftChanged;

  @override
  Widget build(BuildContext context) => _Panel(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Appearance',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: _text)),
            const SizedBox(height: 8),
            _CompactField(
                controller: textController,
                label: 'Text override (optional)',
                icon: Icons.text_fields),
            const SizedBox(height: 8),
            _CompactField(
                controller: contentController,
                label: 'Content override (optional)',
                icon: Icons.notes_outlined),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                    child: _ColorButton(
                        label: 'Text color',
                        color: textColor,
                        onTap: () => _pickColor(
                            context, textColor, onTextColorChanged))),
                const SizedBox(width: 8),
                Expanded(
                    child: _ColorButton(
                        label: 'Content color',
                        color: contentColor,
                        onTap: () => _pickColor(
                            context, contentColor, onContentColorChanged))),
              ],
            ),
            const SizedBox(height: 4),
            _AppearanceSwitch(
                label: 'Draw logo',
                value: drawLogo,
                onChanged: onDrawLogoChanged),
            _AppearanceSwitch(
                label: 'Draw only content',
                value: drawOnlyContent,
                onChanged: onDrawOnlyContentChanged),
            _AppearanceSwitch(
                label: 'Align content left',
                value: contentAlignLeft,
                onChanged: onContentAlignLeftChanged),
            _FileChoice(
                label: 'Logo file', path: logoPath, onChanged: onLogoChanged),
            _FileChoice(
                label: 'Image file',
                path: imagePath,
                onChanged: onImageChanged),
          ],
        ),
      );

  Future<void> _pickColor(BuildContext context, Color current,
      ValueChanged<Color> onChanged) async {
    final picked = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose color', style: TextStyle(fontSize: 17)),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            Colors.black,
            Colors.white,
            Color(0xFF1460F3),
            Color(0xFF16803C),
            Color(0xFFD92D20),
            Color(0xFF6B7280)
          ].map((color) => _ColorChoice(color: color)).toList(),
        ),
      ),
    );
    if (picked != null) onChanged(picked);
  }
}

class _AppearanceSwitch extends StatelessWidget {
  const _AppearanceSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Switch(value: value, onChanged: onChanged),
        ],
      );
}

class _ColorChoice extends StatelessWidget {
  const _ColorChoice({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => Navigator.of(context).pop(color),
        child: CircleAvatar(
            backgroundColor: color,
            radius: 18,
            child: color == Colors.white
                ? const Icon(Icons.check, size: 16)
                : null),
      );
}

class _CompactField extends StatelessWidget {
  const _CompactField(
      {required this.controller, required this.label, required this.icon});
  final TextEditingController controller;
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
          labelText: label, prefixIcon: Icon(icon), isDense: true));
}

class _ColorButton extends StatelessWidget {
  const _ColorButton(
      {required this.label, required this.color, required this.onTap});
  final String label;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
      onPressed: onTap,
      icon: CircleAvatar(radius: 7, backgroundColor: color),
      label: Text(label, style: const TextStyle(fontSize: 11)));
}

class _FileChoice extends StatelessWidget {
  const _FileChoice(
      {required this.label, required this.path, required this.onChanged});
  final String label;
  final String? path;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              child: Text(
                  path == null
                      ? '$label: not selected'
                      : '$label: ${path!.split('/').last}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: _muted))),
          TextButton.icon(
            onPressed: () async {
              final result = await FilePicker.platform
                  .pickFiles(type: FileType.image, withData: false);
              onChanged(result?.files.single.path);
            },
            icon: const Icon(Icons.attach_file, size: 16),
            label: const Text('Choose', style: TextStyle(fontSize: 11)),
          ),
        ],
      );
}

class _CertificateOption extends StatelessWidget {
  const _CertificateOption({
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
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: enabled ? _border : _border.withValues(alpha: .5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: enabled ? _primary : _muted, size: 22),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _text,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedCertificate extends StatelessWidget {
  const _SelectedCertificate({required this.certificate});

  final DigitalSignatureCertificateSession? certificate;

  @override
  Widget build(BuildContext context) {
    if (certificate == null) {
      return const _Panel(
        child: Row(
          children: [
            Icon(Icons.info_outline, color: _muted, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'No certificate selected',
                style: TextStyle(color: _muted, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }
    return _Panel(
      child: Row(
        children: [
          const Icon(Icons.verified_outlined, color: _primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  certificate!.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  certificate!.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignatureTextField extends StatelessWidget {
  const _SignatureTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12),
        textInputAction: textInputAction,
        onSubmitted: onSubmitted ?? (_) => FocusScope.of(context).nextFocus(),
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          isDense: true,
        ),
      );
}

class _SignaturePreview extends StatelessWidget {
  const _SignaturePreview({
    required this.name,
    required this.reason,
    required this.location,
  });

  final String name;
  final String reason;
  final String location;

  @override
  Widget build(BuildContext context) => _Panel(
        color: const Color(0xFFEEF5FF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Signature preview',
              style: TextStyle(
                color: _text,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _PreviewLine(label: 'Name', value: name),
            _PreviewLine(label: 'Reason', value: reason),
            _PreviewLine(label: 'Location', value: location),
          ],
        ),
      );
}

class _PreviewLine extends StatelessWidget {
  const _PreviewLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 62,
              child: Text(label,
                  style: const TextStyle(color: _muted, fontSize: 11)),
            ),
            Expanded(
              child: Text(
                value.isEmpty ? 'Not set' : value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _text, fontSize: 11),
              ),
            ),
          ],
        ),
      );
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.color = Colors.white});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: _border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      );
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F0),
          border: Border.all(color: const Color(0xFFFFCCC7)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: _error, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: _error, fontSize: 12),
              ),
            ),
          ],
        ),
      );
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.verified_user_outlined, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 112,
              child: Text(
                label,
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(color: _text, fontSize: 12),
              ),
            ),
          ],
        ),
      );
}

class _VerificationRow extends StatelessWidget {
  const _VerificationRow({required this.label, required this.value});

  final String label;
  final bool? value;

  @override
  Widget build(BuildContext context) {
    final color = value == null
        ? _muted
        : value!
            ? const Color(0xFF16803C)
            : _error;
    final icon = value == null
        ? Icons.remove_circle_outline
        : value!
            ? Icons.check_circle_outline
            : Icons.cancel_outlined;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child:
                Text(label, style: const TextStyle(color: _text, fontSize: 12)),
          ),
          Text(
            value == null
                ? 'Unavailable'
                : value!
                    ? 'Yes'
                    : 'No',
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
