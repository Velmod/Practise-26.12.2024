import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Информация о объектах',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> items = ['Квартира', 'Дом'];
  String? selectedItem;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();
  final TextEditingController areaController = TextEditingController();

  void _saveData() {
    final String address = addressController.text;
    if (selectedItem != null && address.isNotEmpty) {
      // Создаем объект данных
      Map<String, dynamic> data = {
        'address': address,
        'item': selectedItem,
        'price': priceController.text,
        'rooms': roomsController.text,
        'area': areaController.text,
      };

      // Кодируем данные в текстовом формате
      final textData = StringBuffer();
      textData.writeln('Адрес: $address');
      textData.writeln('Объект: $selectedItem');
      textData.writeln('Стоимость: ${priceController.text}');
      textData.writeln('Количество комнат: ${roomsController.text}');
      textData.writeln('Площадь (м²): ${areaController.text}');

      // Создаем файл для скачивания
      final blob = html.Blob([textData.toString()], 'text/plain');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', '$address.txt') // Название файла
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Данные сохранены в файл!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Пожалуйста, заполните все поля!')));
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    priceController.dispose();
    roomsController.dispose();
    areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить объект недвижимости'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Адрес'),
              validator: (value) => value!.isEmpty ? 'Введите адрес' : null,
            ),
            DropdownButtonFormField<String>(
              value: selectedItem,
              hint: Text('Выберите объект'),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                });
              },
              validator: (value) => value == null ? 'Выберите объект' : null,
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Стоимость'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Введите стоимость' : null,
            ),
            TextFormField(
              controller: roomsController,
              decoration: InputDecoration(labelText: 'Количество комнат'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? 'Введите количество комнат' : null,
            ),
            TextFormField(
              controller: areaController,
              decoration: InputDecoration(labelText: 'Площадь (м²)'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Введите площадь' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
