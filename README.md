# flutter_movie
Đề tài: Flutter working with api

## Thư viện sử dụng

```yaml

dependencies:
  retrofit: ^3.0.1+1 // gọi api

dev_dependencies:
  retrofit_generator: ^4.0.1 // gen file api service
  build_runner: ^2.1.10 // hỗ trợ gen file
  json_serializable: ^6.1.6  // gen model parse json
  json_annotation: ^4.4.0 // gắn annotation để nhận biết model cần gen 

```

## Hướng dẫn chạy project

Tải các thử viện có trong pubspec.yml:

```sh
# flutter 
flutter pub get
```

Gen các file *.g.dart bằng build_runner:

```sh
# flutter 
flutter pub run build_runner build
```

=> Bật máy ảo lên và chạy

## Hướng dẫn gen file

Nếu sửa các file có dòng bên dưới thì gen lại bằng build_runner:

`part '*.g.dart'`

```sh
# flutter 
flutter pub run build_runner build --delete-conflicting-outputs
```

## Demo

![](demo.gif)

## Directory structure

```
|-- web                <- Thư mục code web
|-- tests              <- Unit tests
|-- android            <- Thư mục android
|-- ios                <- Thư mục ios
|-- lib                <- Project data
|   |-- models         <- Nơi chứa các model
|   |-- resource       <- Làm việc với api
|   |-- ui             <- Chứa các giao diện
|-- pubspec.yml        <- Nơi lưu trữ packege thư viện
|-- README.md          <- README của dự án
```
