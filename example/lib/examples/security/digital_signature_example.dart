// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:async';
import 'dart:io';

import 'package:compdfkit_flutter/annotation/form/cpdf_signature_widget.dart';
import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/asset_paths.dart';
import '../shared/example_document_loader.dart';
import 'digital_signature/digital_signature_flow.dart';
import 'digital_signature/digital_signature_widgets.dart';

/// Demonstrates intercepting and digitally signing a real PDF signature field.
///
/// The page opens a one-page document with an unsigned `Approval` field. The
/// callback from [CPDFReaderWidget] is handled in Flutter, then
/// [CPDFDocument.writeSignature] writes a new signed PDF, optionally with an
/// embedded RFC 3161 timestamp, and reloads it in the same Reader widget.
/// Tapping a signed field shows verification, timestamp and LTV state, and
/// [CPDFDocument.addSignatureLtv] can add LTV material to a new copy.
/// The AppBar "Open PDF" action loads a local PDF, for example one that is
/// already signed with LTV material, to inspect its timestamp and LTV state.
class DigitalSignatureExample extends StatelessWidget {
  /// Creates the Digital Signature example.
  const DigitalSignatureExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleDocumentLoader(
      title: 'Digital Signature',
      assetPath: AppAssets.unsignedSignaturePdf,
      builder: (documentPath) => _DigitalSignaturePage(
        documentPath: documentPath,
      ),
    );
  }
}

class _DigitalSignaturePage extends StatefulWidget {
  const _DigitalSignaturePage({required this.documentPath});

  final String documentPath;

  @override
  State<_DigitalSignaturePage> createState() => _DigitalSignaturePageState();
}

class _DigitalSignaturePageState extends State<_DigitalSignaturePage> {
  late String _documentPath;
  CPDFReaderWidgetController? _controller;
  String? _busyMessage;
  bool _isHandlingField = false;
  DigitalSignatureCertificateSession? _lastCertificateSession;
  String? _lastWidgetActionUuid;
  DateTime? _lastWidgetActionTime;

  @override
  void initState() {
    super.initState();
    _documentPath = widget.documentPath;
  }

  CPDFConfiguration get _configuration => CPDFConfiguration(
        toolbarConfig: CPDFToolbarConfig(mainToolbarVisible: true),
        readerViewConfig: CPDFReaderViewConfig(formFieldHighlight: true),
        formsConfig: const CPDFFormsConfig(
          interceptFormWidgetActions: [CPDFFormType.signaturesFields],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Digital Signature'),
        actions: [
          IconButton(
            tooltip: 'Open PDF',
            onPressed: _busyMessage == null ? _openPdf : null,
            icon: const Icon(Icons.folder_open_outlined),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CPDFReaderWidget(
            key: ValueKey(_documentPath),
            document: _documentPath,
            configuration: _configuration,
            onCreated: (controller) => _controller = controller,
            onIOSClickBackPressed: () => Navigator.of(context).maybePop(),
            onInterceptWidgetActionCallback: (widget) {
              if (widget is CPDFSignatureWidget) {
                final now = DateTime.now();
                if (widget.uuid.isNotEmpty &&
                    widget.uuid == _lastWidgetActionUuid &&
                    _lastWidgetActionTime != null &&
                    now.difference(_lastWidgetActionTime!).inMilliseconds <
                        1000) {
                  return;
                }
                _lastWidgetActionUuid = widget.uuid;
                _lastWidgetActionTime = now;
                unawaited(_handleSignatureField(widget));
              }
            },
          ),
          if (_busyMessage != null)
            ColoredBox(
              color: Color(0x66000000),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
                        Text(_busyMessage!),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleSignatureField(CPDFSignatureWidget widget) async {
    if (_busyMessage != null || _isHandlingField || _controller == null) {
      return;
    }
    final controller = _controller!;
    _isHandlingField = true;
    var stage = 'opening the signed field';
    try {
      if (!widget.isSigned) {
        final result = await showDigitalSignatureSheet(
          context: context,
          fieldName: widget.title.isEmpty ? 'Signature field' : widget.title,
          onChooseExisting: _chooseExistingCertificate,
          onCreateCertificate: _createCertificate,
        );
        if (result != null && mounted) {
          await _writeSignature(controller, widget, result);
        }
        return;
      }

      stage = 'loading digital signature metadata';
      final signatures = await controller.document.getDigitalSignatures();
      stage = 'matching the signed field';
      final match = DigitalSignatureFlow.findSignature(widget, signatures);
      if (!mounted) {
        return;
      }

      if (match != null) {
        CPDFDigitalSignatureVerificationResult? verification;
        CPDFLtvReadiness? ltvReadiness;
        var signatureInfo = match.info;
        try {
          stage = 'verifying the digital signature';
          verification =
              await controller.document.verifyDigitalSignature(match.index);
          stage = 'refreshing digital signature metadata';
          final refreshedSignatures =
              await controller.document.getDigitalSignatures();
          signatureInfo =
              DigitalSignatureFlow.findSignature(widget, refreshedSignatures)
                      ?.info ??
                  signatureInfo;
          stage = 'inspecting LTV material';
          ltvReadiness = await controller.document.getLtvReadiness();
        } on PlatformException {
          // Metadata is still useful when verification is unavailable.
        }
        if (mounted) {
          await showDigitalSignatureInfoDialog(
            context: context,
            info: signatureInfo,
            verification: verification,
            ltvReadiness: ltvReadiness,
            onAddLtv: (appendDocumentTimestamp) =>
                _addLtv(controller, appendDocumentTimestamp),
            onTrustCertificate: _lastCertificateSession == null
                ? null
                : () async {
                    final session = _lastCertificateSession!;
                    final trusted = await ComPDFKit.addTrustedCertificate(
                      session.path,
                      session.password,
                    );
                    if (trusted) {
                      _showMessage('Certificate added to the trust store.');
                    }
                    return trusted;
                  },
          );
        }
        return;
      }

      _showError('Signed field metadata is unavailable.');
    } on PlatformException catch (error) {
      _showError(
          '$stage failed: ${error.message ?? 'Unknown platform error.'}');
    } catch (error) {
      _showError('$stage failed: $error');
    } finally {
      _isHandlingField = false;
    }
  }

  Future<DigitalSignatureCertificateSession?>
      _chooseExistingCertificate() async {
    final selection = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['p12', 'pfx'],
      withData: false,
    );
    final path = selection?.files.single.path;
    if (path == null || path.isEmpty) {
      return null;
    }
    if (!mounted) {
      return null;
    }

    // The password dialog is opened only after a certificate path exists.
    final password = await showCertificatePasswordDialog(
      context: context,
      certificateName: path.split(Platform.pathSeparator).last,
      validatePassword: (value) =>
          ComPDFKit.checkPkcs12CertificatePassword(path, value),
    );
    if (password == null) {
      return null;
    }
    if (!mounted) {
      return null;
    }

    final info = await ComPDFKit.loadPkcs12Certificate(path, password);
    if (info == null) {
      throw StateError('The certificate metadata could not be loaded.');
    }
    return DigitalSignatureCertificateSession(
      path: path,
      password: password,
      info: info,
    );
  }

  Future<DigitalSignatureCertificateSession?> _createCertificate() async {
    final creation = await showCreateCertificateDialog(context: context);
    if (creation == null) {
      return null;
    }

    final temporaryDirectory = await ComPDFKit.getTemporaryDirectory();
    final certificateDirectory = Directory(
      '${temporaryDirectory.path}${Platform.pathSeparator}'
      'digital_signature${Platform.pathSeparator}certificates',
    );
    await certificateDirectory.create(recursive: true);
    final certificatePath =
        '${certificateDirectory.path}${Platform.pathSeparator}'
        'example_certificate_${DateTime.now().millisecondsSinceEpoch}.p12';

    final created = await ComPDFKit.generatePkcs12Certificate(
      CPDFCertificateRequest(
        subject: CPDFCertificateSubject(
          commonName: creation.commonName,
          country: creation.country.isEmpty ? null : creation.country,
          state: creation.state.isEmpty ? null : creation.state,
          locality: creation.locality.isEmpty ? null : creation.locality,
          organization:
              creation.organization.isEmpty ? null : creation.organization,
          organizationalUnit: creation.organizationalUnit.isEmpty
              ? null
              : creation.organizationalUnit,
          email: creation.email.isEmpty ? null : creation.email,
        ),
        password: creation.password,
        outputPath: certificatePath,
      ),
    );
    if (!created) {
      throw StateError('The certificate could not be created.');
    }

    final info = await ComPDFKit.loadPkcs12Certificate(
      certificatePath,
      creation.password,
    );
    if (info == null) {
      throw StateError('The created certificate could not be loaded.');
    }
    return DigitalSignatureCertificateSession(
      path: certificatePath,
      password: creation.password,
      info: info,
    );
  }

  Future<void> _writeSignature(
    CPDFReaderWidgetController controller,
    CPDFSignatureWidget widget,
    DigitalSignatureSheetResult request,
  ) async {
    setState(() => _busyMessage = request.timestampServerUrl == null
        ? 'Signing PDF...'
        : 'Signing PDF and requesting timestamp...');
    try {
      final temporaryDirectory = await ComPDFKit.getTemporaryDirectory();
      final outputDirectory = Directory(
        '${temporaryDirectory.path}${Platform.pathSeparator}'
        'digital_signature',
      );
      await outputDirectory.create(recursive: true);
      final outputPath = DigitalSignatureFlow.signedOutputPath(
        outputDirectory.path,
        DateTime.now(),
      );

      // This is the complete Flutter-side signing call customers can reuse.
      final success = await controller.document.writeSignature(
        widget,
        outputPath,
        CPDFDigitalSignatureConfig(
          certificatePath: request.certificate.path,
          password: request.certificate.password,
          name: request.name,
          reason: request.reason,
          location: request.location,
          permissions: request.permissions,
          appearance: request.appearance,
          timestampServerUrl: request.timestampServerUrl,
        ),
      );
      if (!success || !await File(outputPath).exists()) {
        throw StateError('The signed PDF was not created.');
      }
      if (!mounted) {
        return;
      }

      // Changing the key recreates CPDFReaderWidget and opens the new file in
      // the same Flutter flow, so signed-field interception remains active.
      setState(() {
        _controller = null;
        _documentPath = outputPath;
        _lastCertificateSession = request.certificate;
      });
      _showMessage('Signed PDF opened. Tap the field again for its details.');
    } on PlatformException catch (error) {
      _showError(error.message ?? 'The PDF could not be signed.');
    } catch (_) {
      _showError('The PDF could not be signed.');
    } finally {
      if (mounted) {
        setState(() => _busyMessage = null);
      }
    }
  }

  /// Adds LTV material to the open signed PDF and reopens the new copy.
  ///
  /// Returns an error message for the info sheet, or `null` on success.
  Future<String?> _addLtv(
    CPDFReaderWidgetController controller,
    bool appendDocumentTimestamp,
  ) async {
    final selection = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pem', 'crt', 'cer'],
      withData: false,
    );
    final trustedRootPath = selection?.files.single.path;
    if (trustedRootPath == null || trustedRootPath.isEmpty) {
      return 'Select the PEM root certificate of the signer chain.';
    }
    if (!mounted) {
      return null;
    }
    setState(() => _busyMessage = 'Collecting LTV material...');
    try {
      final temporaryDirectory = await ComPDFKit.getTemporaryDirectory();
      final outputDirectory = Directory(
        '${temporaryDirectory.path}${Platform.pathSeparator}'
        'digital_signature',
      );
      await outputDirectory.create(recursive: true);
      final (ltvPath, ltaPath) = DigitalSignatureFlow.ltvOutputPaths(
        outputDirectory.path,
        DateTime.now(),
      );

      // The current document must already be saved; LTV is written to a copy.
      final result = await controller.document.addSignatureLtv(
        ltvPath,
        CPDFSignatureLtvOptions(
          trustedCertificatePath: trustedRootPath,
          appendDocumentTimestamp: appendDocumentTimestamp,
          timestampServerUrl:
              appendDocumentTimestamp ? 'http://timestamp.digicert.com' : null,
          timestampOutputPath: appendDocumentTimestamp ? ltaPath : null,
        ),
      );
      if (!result.success) {
        return result.errors.isEmpty
            ? 'The LTV material could not be added.'
            : result.errors.map((issue) => issue.toString()).join('\n');
      }
      if (!mounted) {
        return null;
      }
      setState(() {
        _controller = null;
        _documentPath = result.finalPath;
      });
      _showMessage('LTV-enabled PDF opened. Tap the field to verify it.');
      return null;
    } on PlatformException catch (error) {
      return error.message ?? 'The LTV material could not be added.';
    } finally {
      if (mounted) {
        setState(() => _busyMessage = null);
      }
    }
  }

  /// Opens a local PDF, such as an already signed or LTV-enabled document,
  /// so its timestamp and LTV state can be inspected.
  Future<void> _openPdf() async {
    final selection = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: false,
    );
    final path = selection?.files.single.path;
    if (path == null || path.isEmpty || !mounted) {
      return;
    }
    setState(() {
      _controller = null;
      _documentPath = path;
      _lastCertificateSession = null;
    });
    _showMessage('PDF opened. Tap a signature field for its details.');
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(message),
        ),
      );
  }
}
