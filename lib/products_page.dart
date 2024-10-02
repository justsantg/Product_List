import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:products_list/edit_product_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Box? productBox;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productBox = Hive.box('productBox');
  }

  void _addProduct() {
    final newProduct = {
      'quantity': int.parse(_quantityController.text),
      'productType': _productTypeController.text,
      'customerName': _customerNameController.text,
      'price': double.parse(_priceController.text),
      'entryDate': DateTime.now().toString(),
    };
    setState(() {
      productBox?.add(newProduct);
    });
    _quantityController.clear();
    _productTypeController.clear();
    _customerNameController.clear();
    _priceController.clear();
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de que deseas eliminar este pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  productBox?.deleteAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _editProduct(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProductPage(index: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Product List'),
  backgroundColor: Colors.red,
  foregroundColor: Colors.white,
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
            onPressed: _addProduct,
            child: const Text('Agregar Pedido'),
          ),
          Expanded(
            child: productBox != null && productBox!.isNotEmpty
                ? ListView.builder(
                    itemCount: productBox!.length,
                    itemBuilder: (context, index) {
                      final product = productBox!.getAt(index);
                      return ListTile(
                        title: Text(
                          'Cantidad: ${product['quantity']} - Tipo de Producto: ${product['productType']} - Nombre del Cliente: ${product['customerName']} - Precio: ${product['price']} - Fecha de Entrada: ${product['entryDate']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editProduct(index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteProduct(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('No hay pedidos agregados'),
                  ),
          ),
        ],
      ),
    );
  }
}