import '../../domain/model/entrance_content_model.dart';

class EntranceContentViewModel {
  final String entranceTitle;

  EntranceContentViewModel({required this.entranceTitle});

  EntranceContentCollection getEntranceContent() {
    return EntranceContentCollection(
      lectures: _generateLectures(),
      notes: _generateNotes(),
      mcqs: _generateMCQs(),
    );
  }

  List<EntranceContent> _generateLectures() {
    List<EntranceContent> lectures = [];
    
    for (int i = 1; i <= 10; i++) {
      String subject = i <= 4 ? 'Physics' : (i <= 7 ? 'Chemistry' : 'Biology');
      int chapterNum = (i % 3) + 1;
      int lectureNum = ((i - 1) % 3) + 1;
      
      lectures.add(EntranceContent(
        title: '$subject Chapter $chapterNum || Lecture $lectureNum',
        subtitle: 'Introduction to $subject',
        source: 'from $entranceTitle Batch',
        imageUrl: 'assets/physics.png',
        isUnlocked: i <= 3, // Only first 3 lectures are unlocked
      ));
    }
    
    return lectures;
  }

  List<EntranceContent> _generateNotes() {
    List<EntranceContent> notes = [];
    
    for (int i = 1; i <= 10; i++) {
      String subject = i <= 4 ? 'Physics' : (i <= 7 ? 'Chemistry' : 'Biology');
      int chapterNum = i;
      
      notes.add(EntranceContent(
        title: '$subject Notes Chapter $chapterNum',
        subtitle: 'Complete Study Material',
        source: 'from $entranceTitle Batch',
        imageUrl: 'assets/books.png', // Using books.png as icon
        isUnlocked: i <= 3, // Only first 3 notes are unlocked
      ));
    }
    
    return notes;
  }

  List<EntranceContent> _generateMCQs() {
    List<EntranceContent> mcqs = [];
    
    for (int i = 1; i <= 10; i++) {
      String subject = i <= 4 ? 'Physics' : (i <= 7 ? 'Chemistry' : 'Biology');
      
      mcqs.add(EntranceContent(
        title: '$subject MCQs Set $i',
        subtitle: '50 Questions with Solutions',
        source: 'from $entranceTitle Batch',
        imageUrl: 'assets/test.png', // Using test.png as icon
        isUnlocked: i <= 3, // Only first 3 MCQs are unlocked
      ));
    }
    
    return mcqs;
  }
}