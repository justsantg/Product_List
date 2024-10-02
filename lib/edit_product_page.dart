import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class EditProductPage extends StatefulWidget {
  final int index;

  const EditProductPage({super.key, required this.index});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  Box? productBox;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productBox = Hive.box('productBox');
    final product = productBox?.getAt(widget.index);
    _quantityController.text = product['quantity'].toString();
    _productTypeController.text = product['productType'];
    _customerNameController.text = product['customerName'];
    _priceController.text = product['price'].toString();
  }

  void _saveEdit() {
    final product = {
      'quantity': int.parse(_quantityController.text),
      'productType': _productTypeController.text,
      'customerName': _customerNameController.text,
      'price': double.parse(_priceController.text),
      'entryDate': DateTime.now().toString(),
    };
    setState(() {
      productBox?.putAt(widget.index, product);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pedido'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _productTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Producto',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Cliente',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _saveEdit,
            child: const Text('Guardar Edición'),
          ),
        ],
      ),
    );
  }
}