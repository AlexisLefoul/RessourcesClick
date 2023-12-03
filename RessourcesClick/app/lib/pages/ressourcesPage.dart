import 'package:flutter/material.dart';
import 'dart:async';
import 'recipesPage.dart';
import 'package:app/models/resource.dart';
import 'package:app/models/product.dart';
import 'inventairePage.dart';

class RessourcesPage extends StatefulWidget {
  const RessourcesPage({super.key});

  @override
  _RessourcesPageState createState() => _RessourcesPageState();
}

class _RessourcesPageState extends State<RessourcesPage> {
  List<Product> products = [];

  List<Resource> resources = [
    Resource(
        name: 'Bois',
        color: const Color(0xFF967969),
        description: 'Du bois brut'),
    Resource(
      name: 'Minerai de fer',
      color: const Color(0xFFced4da),
      description: 'Du minerai de fer brut',
      quantity: 999,
    ),
    Resource(
      name: 'Minerai de cuivre',
      color: const Color(0xFFd9480f),
      description: 'Du minerai de cuivre brut',
      quantity: 999,
    ),
  ];

  bool isCharbonAvailable = false;

  @override
  void initState() {
    super.initState();
    // Utiliser un intervalle pour vérifier régulièrement si les conditions sont remplies
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resources[1].quantity >= 1000 && resources[2].quantity >= 1000) {
        if (!isCharbonAvailable) {
          setState(() {
            isCharbonAvailable = true;
            resources.add(Resource(
              name: 'Charbon',
              color: Colors.black,
              description: 'Du minerai de charbon',
              quantity: 0,
            ));
          });
        }
      } else {
        isCharbonAvailable = false;
        resources.remove(resources[3]);
      }
    });
  }

  Future<void> navigateToRecipesPage(BuildContext context) async {
    final updatedResourceCounts = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecipesPage(resources: resources, products: products),
      ),
    );

    // Mettre à jour les quantités de ressources avec les données reçues
    if (updatedResourceCounts != null) {
      setState(() {
        resources[0].quantity =
            updatedResourceCounts['Bois'] ?? resources[0].quantity;
        resources[1].quantity =
            updatedResourceCounts['Minerai de fer'] ?? resources[1].quantity;
        resources[2].quantity =
            updatedResourceCounts['Minerai de cuivre'] ?? resources[2].quantity;

        products = List.from(updatedResourceCounts['products']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ressources'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50, bottom: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: const Icon(Icons.food_bank, size: 30),
                    onPressed: () {
                      navigateToRecipesPage(context);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.inventory, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InventairePage(products: products)),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 1000,
                height: 350,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 50,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: resources.length,
                  itemBuilder: (context, index) {
                    return ResourceTile(
                        resource: resources[index], products: products);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResourceTile extends StatefulWidget {
  final Resource resource;
  List<Product> products = [];

  ResourceTile({Key? key, required this.resource, required this.products})
      : super(key: key);

  @override
  _ResourceTileState createState() => _ResourceTileState();
}

class _ResourceTileState extends State<ResourceTile> {
  void _mineResource() {
    setState(() {
      if (widget.resource.name == "Bois") {
        if (widget.products.map((e) => e.name == "Hache").isNotEmpty) {
          widget.resource.quantity = widget.resource.quantity + 3;
        } else {
          widget.resource.quantity++;
        }
      }

      if (widget.resource.name.contains("Minerai")) {
        if (widget.products.map((e) => e.name == "Pioche").isNotEmpty) {
          widget.resource.quantity = widget.resource.quantity + 5;
        } else {
          widget.resource.quantity++;
        }
      }

      if (widget.resource.name == "Charbon") {
        if (widget.products.map((e) => e.name == "Pioche").isNotEmpty) {
          widget.resource.quantity = widget.resource.quantity + 5;
        } else {
          widget.resource.quantity++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.resource.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Text(
                  '${widget.resource.name} :',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '${widget.resource.quantity}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _mineResource,
            child: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Miner'),
                  ),
                  widget.resource.name.contains('Bois')
                      ? const Icon(Icons.carpenter)
                      : const Icon(Icons.hardware),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
