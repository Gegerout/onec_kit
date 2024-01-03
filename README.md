# 1C Kit

A Flutter package for dynamic UI component generation.

## Features

- **Dynamic Screens:** Create Flutter screens dynamically.
- **Dynamic Windows:** Generate associated windows dynamically.

## Installation

```yaml
dependencies:
  onec_kit: ^0.0.1

```dart
import 'package:your_package_name/your_package_name.dart';

void main() {
  final dataScreenModel = ObjectDataScreenModel(
    // ...your data model configuration
  );

  runApp(MaterialApp(
    home: generateObjectDataScreen(dataScreenModel),
  ));
}

