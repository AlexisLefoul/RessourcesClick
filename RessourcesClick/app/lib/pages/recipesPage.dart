import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:app/models/recipe.dart';
import 'package:app/models/resource.dart';
import 'package:app/models/product.dart';

class RecipesPage extends StatefulWidget {
  final List<Resource> resources;
  List<Product> products;

  RecipesPage({Key? key, required this.resources, required this.products})
      : super(key: key);

  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final List<Recipe> recipes = [
    Recipe(
        name: 'Hache',
        description: 'Un outil utile',
        cost: {'Bois': 2, 'Tige en métal': 2}),
    Recipe(
        name: 'Pioche',
        description: 'Un outil utile',
        cost: {'Bois': 2, 'Tige en métal': 3}),
    Recipe(
        name: 'Lingot de fer',
        description: 'Un lingot de fer pur',
        cost: {'Minerai de fer': 1}),
    Recipe(
      name: 'Plaque de fer',
      description: 'Une plaque de fer pour la construction',
      cost: {'Minerai de fer': 3},
    ),
    Recipe(
        name: 'Lingot de cuivre',
        description: 'Un lingot de cuivre pur',
        cost: {'Minerai de cuivre': 1}),
    Recipe(
      name: 'Tige en métal',
      description: 'Une tige de métal',
      cost: {'Lingot de fer': 1},
    ),
    Recipe(
      name: 'Fil électrique',
      description:
          ' Un fil électrique pour fabriquer des composants électroniques',
      cost: {'Lingot de cuivre': 1},
    ),
    Recipe(
      name: 'Mineur',
      description: 'Un bâtiment qui permet d’automatiser le minage',
      cost: {'Plaque de fer': 10, 'Fil électrique': 5},
    ),
    Recipe(
      name: 'Fonderie',
      description: 'Un bâtiment qui permet d’automatiser la production.',
      cost: {'Fil électrique': 5, 'Tige en métal': 8},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int updatedWoodCount = 0;
    int updatedIronOreCount = 0;
    int updatedCopperOreCount = 0;

    bool _canProduceItem(Map<String, int> cost) {
      for (var entry in cost.entries) {
        var resourceName = entry.key;
        var resourceCost = entry.value;

        Resource? existingResource = widget.resources.firstWhereOrNull(
          (resource) => resource.name == resourceName,
        );

        if (existingResource == null) {
          Product? existingProduct = widget.products.firstWhereOrNull(
            (product) => product.name == resourceName,
          );

          if (existingProduct == null) {
            return false;
          } else if (existingProduct.quantity < resourceCost) {
            return false;
          }
        }

        if (existingResource != null &&
            existingResource.quantity < resourceCost) {
          return false;
        }
      }
      return true;
    }

    void _produceItem(Recipe recipe) {
      // Vérifiez si les ressources sont suffisantes pour produire l'objet
      if (_canProduceItem(recipe.cost)) {
        // Créer un nouvel objet et l'ajouter à la liste des produits
        setState(() {
          recipe.cost.forEach((resourceName, resourceCost) {
            Resource? resource = widget.resources.firstWhereOrNull(
              (resource) => resource.name == resourceName,
            );

            if (resource != null) {
              resource.quantity -= resourceCost;
              if (resource.name == "Bois") {
                updatedWoodCount = resource.quantity;
              }
              if (resource.name == "Minerai de fer") {
                updatedIronOreCount = resource.quantity;
              }
              if (resource.name == "Minerai de cuivre") {
                updatedCopperOreCount = resource.quantity;
              }
            } else {
              Product product = widget.products.firstWhere(
                (product) => product.name == resourceName,
              );

              product.quantity -= resourceCost;

              if (product.quantity == 0) {
                widget.products.remove(product);
              }
            }
          });

          // Vérifier si le produit existe déjà dans la liste
          Product? existingProduct = widget.products.firstWhereOrNull(
            (product) => product.name == recipe.name,
          );

          if (existingProduct != null) {
            // Si le produit existe déjà, augmentez sa quantité de 1
            existingProduct.quantity++;
          } else {
            // Sinon, ajoutez le nouveau produit à la liste
            widget.products.add(Product(name: recipe.name, quantity: 1));
          }
        });
      } else {
        // S'il n'y a pas assez de ressources, affichez un message d'erreur ou effectuez une autre action
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ressources insuffisantes'),
              content: const Text(
                  'Vous n\'avez pas assez de ressources pour produire cet objet.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recettes'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Appuyez sur le bouton de retour et renvoyez les nouvelles quantités
            Navigator.pop(context, {
              'woodCount': updatedWoodCount,
              'ironOreCount': updatedIronOreCount,
              'copperOreCount': updatedCopperOreCount,
              'products': widget.products,
            });
          },
        ),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeTile(
              recipe: recipes[index],
              produceItem: _produceItem,
              canProduce: _canProduceItem(recipes[index].cost));
        },
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final Recipe recipe;
  final Function(Recipe recipe) produceItem;
  final bool canProduce;

  const RecipeTile({
    Key? key,
    required this.recipe,
    required this.produceItem,
    required this.canProduce,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(recipe.name),
      subtitle: Row(
        children: [
          Text(recipe.description),
          const Text('. Pour le produire, il faut : '),
          Text(
            _getCostText(recipe.cost),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: canProduce ? () => produceItem(recipe) : null,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: canProduce ? Colors.blue : Colors.grey,
        ),
        child: const SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Produire'),
              SizedBox(width: 5),
              Icon(Icons.construction),
            ],
          ),
        ),
      ),
    );
  }
}

String _getCostText(Map<String, int> cost) {
  String costText = '';
  int index = 0;
  cost.forEach((key, value) {
    costText += '$value $key';
    if (index < cost.length - 1) {
      costText += ' + ';
    }
    index++;
  });
  return costText;
}
