class NTETNote {
  final String title;
  final String chapter;
  final bool isLocked;
  final String pdfPath; // Path to the PDF file

  const NTETNote({
    required this.title,
    required this.chapter,
    this.isLocked = false,
    required this.pdfPath,
  });
}