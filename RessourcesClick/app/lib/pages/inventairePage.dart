import 'package:flutter/material.dart';
import 'package:app/models/product.dart';

class InventairePage extends StatefulWidget {
  final List<Product> products;

  const InventairePage({Key? key, required this.products}) : super(key: key);

  @override
  _InventairePageState createState() => _InventairePageState();
}

class _InventairePageState extends State<InventairePage> {
  bool _isSortedAscending = true;
  bool _sortByQuantity = false;

  void _sortProductsByName() {
    setState(() {
      _isSortedAscending = !_isSortedAscending;
      if (_isSortedAscending) {
        widget.products.sort((a, b) => a.name.compareTo(b.name));
      } else {
        widget.products.sort((a, b) => b.name.compareTo(a.name));
      }
    });
  }

  void _sortProductsByQuantity() {
    setState(() {
      _sortByQuantity = !_sortByQuantity;
      if (_sortByQuantity) {
        widget.products.sort((a, b) => a.quantity.compareTo(b.quantity));
      } else {
        widget.products.sort((a, b) => b.quantity.compareTo(a.quantity));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaire'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            onPressed: _sortProductsByName,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _sortProductsByQuantity,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text('Liste des produits :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.products[index].name),
                    subtitle:
                        Text('Quantité: ${widget.products[index].quantity}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
