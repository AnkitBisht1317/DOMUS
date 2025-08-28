import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_user_info_usecase.dart';

class UserViewModel extends ChangeNotifier {
  final GetUserInfoUseCase _getUserInfoUseCase;
  
  String? _userName;
  bool _isLoading = false;
  String? _error;
  
  UserViewModel(this._getUserInfoUseCase);
  
  String? get userName => _userName;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadUserInfo() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final userInfo = await _getUserInfoUseCase.execute();
      _userName = userInfo.name;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}