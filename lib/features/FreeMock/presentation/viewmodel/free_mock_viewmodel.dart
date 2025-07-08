import '../../domain/model/free_mock_model.dart';

class FreeMockViewModel {
  List<FreeMockModel> getFreeMockList() {
    return [
      FreeMockModel(
          imagePath: 'assets/do.png', title: 'AIAPGET Mock Test Series'),
      FreeMockModel(
          imagePath: 'assets/do.png', title: 'NTET 2025 Mock Test Series'),
      FreeMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set A : Homoeopathy Special'),
      FreeMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set B : Homoeopathy Special'),
      FreeMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set C : Homoeopathy Special'),
      FreeMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set D : Homoeopathy Special'),
      FreeMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set E : Homoeopathy Special'),
      FreeMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set F : Homoeopathy Special'),
    ];
  }
}
