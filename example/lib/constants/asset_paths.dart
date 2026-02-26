// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

/// Asset paths for the application.
///
/// This file centralizes the management of all application resource paths, including images, audio, etc.
/// Naming conventions are followed: resources under each category use descriptive English names to ensure code readability.
class AppAssets {
  // ==================== Annotation Tool Icons ====================

  static const String icNote = 'images/ic_note.svg';
  static const String icHighlight = 'images/ic_highlight.svg';
  static const String icUnderline = 'images/ic_underline.svg';
  static const String icStrikeout = 'images/ic_strikeout.svg';
  static const String icWavyline = 'images/ic_wavyline.svg';
  static const String icInk = 'images/ic_ink.svg';
  static const String icEraser = 'images/ic_eraser.svg';
  static const String icPencil = 'images/ic_pencil.svg';
  static const String icOval = 'images/ic_oval.svg';
  static const String icRec = 'images/ic_rec.svg';
  static const String icArrow = 'images/ic_arrow.svg';
  static const String icLine = 'images/ic_line.svg';
  static const String icText = 'images/ic_text.svg';
  static const String icSign = 'images/ic_sign.svg';
  static const String icStamp = 'images/ic_stamp.svg';
  static const String icImage = 'images/ic_image.svg';
  static const String icLink = 'images/ic_link.svg';
  static const String icSound = 'images/ic_sound.svg';

  // ==================== Navigation/UI Icons ====================

  static const String icHomeSettings = 'images/ic_home_setting.svg';
  static const String icHomeViewer = 'images/ic_home_viewer.svg';
  static const String icSysArrow = 'images/ic_syasarrow.svg';

  // ==================== Logo and Brand ====================

  static const String icLogo = 'images/ic_logo.png';
  static const String icLogo1 = 'images/ic_logo_1.png';
  static const String logo = 'images/logo.png';

  // ==================== Stamp Resources ====================

  static const String stampApproved = 'images/stamp/stamp_approved.png';
  static const String stampNotApproved = 'images/stamp/stamp_not_approved.png';
  static const String stampDraft = 'images/stamp/stamp_draft.png';
  static const String stampFinal = 'images/stamp/stamp_final.png';
  static const String stampCompleted = 'images/stamp/stamp_completed.png';
  static const String stampConfidential = 'images/stamp/stamp_confidential.png';
  static const String stampForPublicRelease =
      'images/stamp/stamp_for_public_release.png';
  static const String stampNotForPublicRelease =
      'images/stamp/stamp_not_for_public_release.png';
  static const String stampForComment = 'images/stamp/stamp_for_comment.png';
  static const String stampVoid = 'images/stamp/stamp_void.png';
  static const String stampPreliminaryResults =
      'images/stamp/stamp_preliminary_results.png';
  static const String stampInformationOnly =
      'images/stamp/stamp_information_only.png';
  static const String stampWitness = 'images/stamp/stamp_witness.png';
  static const String stampInitialHere = 'images/stamp/stamp_initial_here.png';
  static const String stampSignHere = 'images/stamp/stamp_sign_here.png';
  static const String stampRevised = 'images/stamp/stamp_revised.png';
  static const String stampAccepted = 'images/stamp/stamp_accepted.png';
  static const String stampRejected = 'images/stamp/stamp_rejected.png';
  static const String stampPrivateAccepted =
      'images/stamp/stamp_private_accepted.png';
  static const String stampPrivateRejected =
      'images/stamp/stamp_private_rejected.png';
  static const String stampPrivateRadioMark =
      'images/stamp/stamp_private_radio_mark.png';

  // ==================== Signature Resources ====================

  static const String signatureOne = 'images/sign/signature_1.png';
  static const String signatureTwo = 'images/sign/signature_2.png';
  static const String signatureThree = 'images/sign/signature_3.png';
  static const String signatureFour = 'images/sign/signature_4.png';

  // ==================== Sound Resources ====================

  static const String birdWav = 'assets/Bird.wav';

  // ==================== License and Configuration ====================
  static const String licenseKeyFlutter = 'assets/license_key_flutter.xml';

  // ==================== Resource Path Prefixes ====================

  static const String signPrefix = 'images/sign/';
  static const String stampPrefix = 'images/stamp/';

  // ==================== Sample PDF Documents ====================

  /// General sample PDF document
  static const String pdfDocument = 'pdfs/PDF_Document.pdf';

  /// Annotation and form test PDF
  static const String annotTestPdf = 'pdfs/annot_test.pdf';

  /// Password-protected PDF (password: compdfkit)
  static const String passwordProtectedPdf =
      'pdfs/Password_compdfkit_Security_Sample_File.pdf';

  // ==================== XFDF Files ====================

  /// Test XFDF file
  static const String testXfdf = 'pdfs/test.xfdf';

  /// Form widgets XFDF file
  static const String annotTestWidgetsXfdf = 'pdfs/annot_test_widgets.xfdf';
}
