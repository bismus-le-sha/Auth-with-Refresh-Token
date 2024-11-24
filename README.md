# Flutter Authentication with Refresh Token

## Overview
This Flutter project demonstrates handling authentication processes such as login, signup, OTP verification, and automatic token refresh using the [Dio HTTP client](https://pub.dev/packages/dio), with secure storage management using [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage).

## Features
- User Authentication (Login, Signup)
- OTP Verification
- Automatic Token Refresh using Interceptors
- Secure Token Storage

## Usage

### Authentication
- **Login**: Use `ApiService().login(email, password)` to authenticate users.
- **Signup**: Use `ApiService().signUp(name, email, password)` to register new users.
- **Verify OTP**: Use `ApiService().verifyOtp(email, otp)` for OTP verification.

### Token Management
- **Securely Store Tokens**: Use `SecureStorageManager.writeData('accessToken', token)` to store tokens securely.
- **Read Tokens**: Use `SecureStorageManager.readData('accessToken')` to retrieve tokens securely.

### Secure API Requests
Ensure all API requests are authenticated using the access token retrieved from secure storage:
```dart
Future<Response> getProductByToken() async {
  final token = await SecureStorageManager.readData('accessToken');
  final response = await _dio.get('/product/1',
      options: Options(headers: {'Authorization': 'Bearer $token'}));
  return response;
}
```
## Handling Token Expiry

The `RefreshTokenInterceptor` automatically handles token expiration by refreshing the token and retrying the original request seamlessly when encountering 401 or 403 errors.

intain secure sessions across multiple services or APIs.


## Contribution

Contributions to the project are welcome! Please fork the repository and submit a pull request with your features or fixes.

## Issues

If you encounter any issues while using this project, please open an issue in the repository with a detailed description of the problem, steps to reproduce it, and the expected behavior. We appreciate your contributions to improving this project.

## Contact

For any questions or feedback, please reach out via email: [mahmoudelsayed.dev@gmail.com](mahmoudelsayed.dev@gmail.com)
