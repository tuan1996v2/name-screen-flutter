# Name Screen Flutter 🏷️

<p align="center">
  <b>Thư viện Flutter hiển thị tag tên màn hình hiện tại dạng nổi (Floating Badge) theo thời gian thực. Hỗ trợ sao chép 1-chạm, kéo thả tự do, lọc popup thông minh và tương thích hoàn toàn với mọi Router (GoRouter, AutoRoute, Navigator 1.0/2.0).</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue.svg" alt="Flutter Version" />
  <img src="https://img.shields.io/badge/Dart-%3E%3D2.18.0-blue.svg" alt="Dart Version" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License" />
</p>

---

## 🤖 1-Prompt Integration (Dành cho AI ở dự án mới)

> **Mẹo:** Khi bắt đầu hoặc bảo trì một dự án Flutter, bạn chỉ cần copy nguyên câu prompt dưới đây và gửi cho AI Assistant (Cursor, Antigravity, Claude Code, GitHub Copilot, Windsurf):

```text
Tích hợp package name_screen_flutter từ git https://github.com/tuan1996v2/name_screen_flutter.git vào dự án này: thêm vào dependencies trong pubspec.yaml, bọc MaterialApp.builder bằng NameScreen(), cắm NameScreenObserver() vào observers của Navigator/GoRouter, sau đó chạy flutter pub get.
```

---

## ✨ Tính Năng Nổi Bật

1. **🏷️ Hiển thị tên màn hình theo thời gian thực (Real-time Screen Tag)**:
   - Tự động bắt tên route (`route.settings.name` hoặc fallback theo `runtimeType`) khi push, pop, replace.
2. **👆 Sao chép 1-chạm (1-Tap Copy to Clipboard)**:
   - Chạm vào tag để copy ngay tên màn hình vào clipboard với hiệu ứng phản hồi sinh động `"Copied!"`. Cực kỳ hữu ích khi Tester hoặc Dev cần log bug hay tìm kiếm code màn hình.
3. **🖐️ Kéo thả tự do (Draggable Positioning)**:
   - Dễ dàng kéo tag di chuyển khắp màn hình nếu tag che mất các nút hành động (AppBar action, nút bấm).
4. **🛡️ Lọc Popup thông minh (Smart Popup Filtering)**:
   - Tự động bỏ qua các Modal Bottom Sheet, DatePicker hay Dialog không có tên để tránh làm nhấp nháy hoặc mất tên màn hình chính bên dưới.
5. **🚀 Tương thích mọi kiến trúc Routing**:
   - Hoạt động mượt mà với **GoRouter**, **AutoRoute**, **Beamer** và **Navigator 1.0 / 2.0**.
6. **🎨 Tùy biến toàn diện (`NameScreenConfig`)**:
   - Tùy chỉnh màu nền, màu chữ, font size, bo góc, giới hạn ký tự hiển thị, vị trí khởi tạo.

---

## 📦 Cài Đặt

Thêm thư viện vào file `pubspec.yaml` của bạn:

```yaml
dependencies:
  flutter:
    sdk: flutter
  name_screen_flutter:
    git:
      url: https://github.com/tuan1996v2/name_screen_flutter.git
      ref: main
```

Sau đó chạy lệnh:
```bash
flutter pub get
```

---

## 🚀 Hướng Dẫn Sử Dụng

### Cách 1: Sử dụng với `GoRouter`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:name_screen_flutter/name_screen_flutter.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  // 1. Thêm NameScreenObserver vào danh sách observers
  observers: [
    NameScreenObserver(),
  ],
  routes: [
    GoRoute(
      path: '/',
      name: 'HomeScreen',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/details',
      name: 'DetailScreen',
      builder: (context, state) => const DetailScreen(),
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Demo App',
      routerConfig: _router,
      // 2. Bọc router builder bằng NameScreen
      builder: (context, child) {
        return NameScreen(
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
```

---

### Cách 2: Sử dụng với `MaterialApp` truyền thống (Navigator 1.0)

```dart
import 'package:flutter/material.dart';
import 'package:name_screen_flutter/name_screen_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      // 1. Thêm NameScreenObserver vào navigatorObservers
      navigatorObservers: [
        NameScreenObserver(),
      ],
      // 2. Bọc builder bằng NameScreen
      builder: (context, child) {
        return NameScreen(
          child: child ?? const SizedBox(),
        );
      },
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
```

---

## ⚙️ Tùy Biến Nâng Cao (`NameScreenConfig`)

Bạn có thể cấu hình chi tiết giao diện và hành vi thông qua `NameScreenConfig`:

```dart
NameScreen(
  // Bật/tắt tag: mặc định tự động kích hoạt khi ở kDebugMode
  // Có thể truyền true/false tùy môi trường (Dev, UAT, Testing)
  enabled: kDebugMode, 
  config: const NameScreenConfig(
    isDraggable: true,                 // Bật/tắt tính năng kéo thả (mặc định: true)
    backgroundColor: Color(0xCC000000),// Màu nền badge (mặc định: đen trong suốt 75%)
    textColor: Colors.white,           // Màu chữ
    indicatorColor: Colors.greenAccent,// Màu chấm tròn trạng thái
    copiedBackgroundColor: Colors.blueAccent, // Màu nền khi vừa bấm copy
    copiedTextColor: Colors.white,     // Màu chữ "Copied!"
    fontSize: 11.0,                    // Kích thước chữ
    maxDisplayLength: 28,              // Tối đa ký tự trước khi hiển thị '...'
    borderRadius: 12.0,                // Bo tròn góc
    initialTop: 6.0,                   // Cách mép trên (Status bar)
    initialRight: 8.0,                 // Cách mép phải màn hình
    copiedFeedbackDuration: Duration(milliseconds: 1500), // Thời gian hiện "Copied!"
  ),
  child: child,
)
```

---

## 🛠️ Tuỳ Chỉnh Trích Xuất Tên Route (`routeNameExtractor`)

Nếu dự án của bạn có định dạng route đặc thù (hoặc muốn loại bỏ tiền tố/hậu tố), bạn có thể truyền custom extractor vào `NameScreenObserver`:

```dart
NameScreenObserver(
  // Tùy biến cách đọc tên route
  routeNameExtractor: (route) {
    final name = route.settings.name;
    if (name != null && name.startsWith('/')) {
      return name.replaceFirst('/', ''); // Bỏ dấu / ở đầu
    }
    return name;
  },
  // Bỏ qua modal bottom sheet / popup không có tên (mặc định: true)
  ignoreUnnamedPopups: true, 
)
```

Hoặc cập nhật thủ công từ bất kỳ đâu:
```dart
NameScreenObserver.updateCurrentRouteName('CustomScreenName');
```

---

## 📄 Giấy Phép (License)

Dự án được phát hành dưới giấy phép [MIT License](LICENSE). Tác giả: **[tuan1996v2](https://github.com/tuan1996v2)**.
