import '../../domain/model/paid_mock_model.dart';

class PaidMockViewModel {
  List<PaidMockModel> getMockList() {
    return [
      PaidMockModel(
          imagePath: 'assets/do.png', title: 'AIAPGET Mock Test Series'),
      PaidMockModel(
          imagePath: 'assets/do.png', title: 'NTET 2025 Mock Test Series'),
      PaidMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set A : Homoeopathy Special'),
      PaidMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set B : Homoeopathy Special'),
      PaidMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set C : Homoeopathy Special'),
      PaidMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set D : Homoeopathy Special'),
      PaidMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set E : Homoeopathy Special'),
      PaidMockModel(
          imagePath: 'assets/do.png',
          title: 'Abhyaas Set F : Homoeopathy Special'),
    ];
  }
}
