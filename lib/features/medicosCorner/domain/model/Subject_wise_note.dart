class SubjectWiseNotes {
  final String title;
  final String chapter;
  final bool isLocked;
  final String pdfPath; // Path to the PDF file
  const SubjectWiseNotes({
    required this.title,
    required this.chapter,
    this.isLocked = false,
    required this.pdfPath,
  });
}
