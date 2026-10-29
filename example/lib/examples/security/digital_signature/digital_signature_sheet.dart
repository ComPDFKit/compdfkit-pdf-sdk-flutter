// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION AND DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

part of 'digital_signature_widgets.dart';

/// Opens the signing form for one intercepted signature field.
Future<DigitalSignatureSheetResult?> showDigitalSignatureSheet({
  required BuildContext context,
  required String fieldName,
  required Future<DigitalSignatureCertificateSession?> Function()
      onChooseExisting,
  required Future<DigitalSignatureCertificateSession?> Function()
      onCreateCertificate,
}) {
  return showModalBottomSheet<DigitalSignatureSheetResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DigitalSignatureBottomSheet(
      fieldName: fieldName,
      onChooseExisting: onChooseExisting,
      onCreateCertificate: onCreateCertificate,
    ),
  );
}

/// Collects certificate and signature metadata before the page writes a PDF.
class DigitalSignatureBottomSheet extends StatefulWidget {
  const DigitalSignatureBottomSheet({
    super.key,
    required this.fieldName,
    required this.onChooseExisting,
    required this.onCreateCertificate,
  });

  final String fieldName;
  final Future<DigitalSignatureCertificateSession?> Function() onChooseExisting;
  final Future<DigitalSignatureCertificateSession?> Function()
      onCreateCertificate;

  @override
  State<DigitalSignatureBottomSheet> createState() =>
      _DigitalSignatureBottomSheetState();
}

class _DigitalSignatureBottomSheetState
    extends State<DigitalSignatureBottomSheet> {
  late final TextEditingController _nameController =
      TextEditingController(text: 'ComPDF Flutter Example');
  late final TextEditingController _reasonController =
      TextEditingController(text: 'Approved document');
  late final TextEditingController _locationController =
      TextEditingController(text: 'Flutter Example');
  late final TextEditingController _appearanceTextController =
      TextEditingController();
  late final TextEditingController _appearanceContentController =
      TextEditingController();
  late final TextEditingController _timestampServerController =
      TextEditingController(text: 'http://timestamp.digicert.com');

  DigitalSignatureCertificateSession? _certificate;
  CPDFSignaturePermission _permissions = CPDFSignaturePermission.fillAndSign;
  Color _textColor = Colors.black;
  Color _contentColor = Colors.black;
  String? _logoPath;
  String? _imagePath;
  bool _drawLogo = false;
  bool _drawOnlyContent = false;
  bool _contentAlignLeft = false;
  bool _embedTimestamp = false;
  bool _loadingCertificate = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_refreshPreview);
    _reasonController.addListener(_refreshPreview);
    _locationController.addListener(_refreshPreview);
    _appearanceTextController.addListener(_refreshPreview);
    _appearanceContentController.addListener(_refreshPreview);
  }

  void _refreshPreview() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_refreshPreview);
    _reasonController.removeListener(_refreshPreview);
    _locationController.removeListener(_refreshPreview);
    _appearanceTextController.removeListener(_refreshPreview);
    _appearanceContentController.removeListener(_refreshPreview);
    _nameController.dispose();
    _reasonController.dispose();
    _locationController.dispose();
    _appearanceTextController.dispose();
    _appearanceContentController.dispose();
    _timestampServerController.dispose();
    super.dispose();
  }

  Future<void> _chooseExisting() async {
    await _loadCertificate(widget.onChooseExisting);
  }

  Future<void> _createCertificate() async {
    await _loadCertificate(widget.onCreateCertificate);
  }

  Future<void> _loadCertificate(
    Future<DigitalSignatureCertificateSession?> Function() action,
  ) async {
    if (_loadingCertificate) {
      return;
    }
    setState(() {
      _loadingCertificate = true;
      _errorMessage = null;
    });
    try {
      final certificate = await action();
      if (!mounted) {
        return;
      }
      if (certificate != null) {
        setState(() => _certificate = certificate);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'The certificate could not be loaded.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loadingCertificate = false);
      }
    }
  }

  void _submit() {
    final certificate = _certificate;
    if (certificate == null) {
      setState(() => _errorMessage = 'Select or create a certificate first.');
      return;
    }
    final timestampServerUrl = _timestampServerController.text.trim();
    if (_embedTimestamp &&
        !DigitalSignatureFlow.isTimestampServerUrl(timestampServerUrl)) {
      setState(() => _errorMessage = 'Enter an http or https TSA URL.');
      return;
    }
    Navigator.of(context).pop(
      DigitalSignatureSheetResult(
        certificate: certificate,
        name: _nameController.text.trim(),
        reason: _reasonController.text.trim(),
        location: _locationController.text.trim(),
        permissions: _permissions,
        appearance: CPDFDigitalSignatureAppearance(
          text: _appearanceTextController.text.trim().isEmpty
              ? _nameController.text.trim()
              : _appearanceTextController.text.trim(),
          content: _appearanceContentController.text.trim().isEmpty
              ? _nativeContent()
              : _appearanceContentController.text.trim(),
          textColor: _textColor,
          contentColor: _contentColor,
          logoPath: _logoPath,
          imagePath: _imagePath,
          drawLogo: _drawLogo,
          drawOnlyContent: _drawOnlyContent,
          contentAlignLeft: _contentAlignLeft,
        ),
        timestampServerUrl: _embedTimestamp ? timestampServerUrl : null,
      ),
    );
  }

  String _nativeContent() {
    final certificateSubject = _certificate?.info?.subject;
    final lines = <String>[
      'Name: ${_nameController.text.trim()}',
      'Date: ${_formatNativeDate(DateTime.now())}',
      'Reason: ${_reasonController.text.trim()}',
      'Location: ${_locationController.text.trim()}',
      if (certificateSubject != null && certificateSubject.isNotEmpty)
        'DN: $certificateSubject',
    ];
    return lines.join('\n');
  }

  String _formatNativeDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${date.year}.${twoDigits(date.month)}.${twoDigits(date.day)} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}:${twoDigits(date.second)}';
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final availableHeight =
        MediaQuery.of(context).size.height - viewInsets.bottom;
    final maxHeight = availableHeight * .9;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Material(
        color: _background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _SheetHeader(
                  title: 'Sign ${widget.fieldName}',
                  onClose: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle(title: 'Certificate'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _CertificateOption(
                              icon: Icons.folder_open_outlined,
                              title: 'Choose existing',
                              subtitle: 'PKCS#12 file',
                              onTap:
                                  _loadingCertificate ? null : _chooseExisting,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _CertificateOption(
                              icon: Icons.add_card_outlined,
                              title: 'Create certificate',
                              subtitle: 'Generate a new PKCS#12',
                              onTap: _loadingCertificate
                                  ? null
                                  : _createCertificate,
                            ),
                          ),
                        ],
                      ),
                      if (_loadingCertificate) ...[
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(minHeight: 2),
                      ],
                      const SizedBox(height: 12),
                      _SelectedCertificate(certificate: _certificate),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 10),
                        _InlineError(message: _errorMessage!),
                      ],
                      const SizedBox(height: 24),
                      const _SectionTitle(
                          title: 'Digital signature information'),
                      const SizedBox(height: 10),
                      _SignatureTextField(
                        controller: _nameController,
                        label: 'Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 10),
                      _SignatureTextField(
                        controller: _reasonController,
                        label: 'Reason',
                        icon: Icons.description_outlined,
                      ),
                      const SizedBox(height: 10),
                      _SignatureTextField(
                        controller: _locationController,
                        label: 'Location',
                        icon: Icons.location_on_outlined,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _dismissKeyboard(),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<CPDFSignaturePermission>(
                        initialValue: _permissions,
                        onTap: _dismissKeyboard,
                        style: const TextStyle(fontSize: 12, color: _text),
                        decoration: const InputDecoration(
                          labelText: 'Permission after signing',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: CPDFSignaturePermission.forbidChange,
                            child: Text('No changes',
                                style: TextStyle(fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: CPDFSignaturePermission.fillAndSign,
                            child: Text('Fill and sign',
                                style: TextStyle(fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value:
                                CPDFSignaturePermission.annotationFillAndSign,
                            child: Text('Annotations, fill and sign',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _permissions = value);
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      _SignatureAppearanceEditor(
                        textController: _appearanceTextController,
                        contentController: _appearanceContentController,
                        textColor: _textColor,
                        contentColor: _contentColor,
                        logoPath: _logoPath,
                        imagePath: _imagePath,
                        drawLogo: _drawLogo,
                        drawOnlyContent: _drawOnlyContent,
                        contentAlignLeft: _contentAlignLeft,
                        onTextColorChanged: (value) =>
                            setState(() => _textColor = value),
                        onContentColorChanged: (value) =>
                            setState(() => _contentColor = value),
                        onLogoChanged: (value) =>
                            setState(() => _logoPath = value),
                        onImageChanged: (value) => setState(() {
                          _imagePath = value;
                          _drawOnlyContent = value == null;
                        }),
                        onDrawLogoChanged: (value) =>
                            setState(() => _drawLogo = value),
                        onDrawOnlyContentChanged: (value) =>
                            setState(() => _drawOnlyContent = value),
                        onContentAlignLeftChanged: (value) =>
                            setState(() => _contentAlignLeft = value),
                      ),
                      const SizedBox(height: 18),
                      const _SectionTitle(title: 'Timestamp'),
                      _AppearanceSwitch(
                        label: 'Embed RFC 3161 timestamp (network required)',
                        value: _embedTimestamp,
                        onChanged: (value) =>
                            setState(() => _embedTimestamp = value),
                      ),
                      if (_embedTimestamp) ...[
                        const SizedBox(height: 6),
                        _SignatureTextField(
                          controller: _timestampServerController,
                          label: 'Timestamp server (TSA) URL',
                          icon: Icons.schedule_outlined,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _dismissKeyboard(),
                        ),
                      ],
                      const SizedBox(height: 18),
                      _SignaturePreview(
                        name: _nameController.text,
                        reason: _reasonController.text,
                        location: _locationController.text,
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: _loadingCertificate ? null : _submit,
                      icon: const Icon(Icons.draw_outlined),
                      label: const Text('Sign and open PDF'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
