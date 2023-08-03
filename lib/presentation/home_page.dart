import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/products/products_bloc.dart';
import 'package:flutter_ecatalog/data/datasources/local_datasource.dart';
import 'package:flutter_ecatalog/data/models/request/product_request_model.dart';
import 'package:flutter_ecatalog/presentation/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;

  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(GetProductsEvent());
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController!.dispose();
    priceController!.dispose();
    descriptionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () async {
              await LocalDataSource().removeToken();
              // ignore: use_build_context_synchronously
              Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return const LoginPage();
                },
              ));
            },
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: ListTile(
                      title:
                          Text(state.data.reversed.toList()[index].title ?? ''),
                      subtitle: Text('Price: ${state.data[index].price}'),
                    ),
                  ),
                );
              },
              itemCount: state.data.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(hintText: 'Title'),
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: 'Price'),
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: 'Description'),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  BlocConsumer<AddProductBloc, AddProductState>(
                    listener: (context, state) {
                      if (state is AddProductLoaded) {
                        const ScaffoldMessenger(
                          child: SnackBar(
                            content: Text('Add product succsess'),
                          ),
                        );
                        context.read<ProductsBloc>().add(GetProductsEvent());
                        titleController!.clear();
                        priceController!.clear();
                        descriptionController!.clear();
                        Navigator.pop(context);
                      }
                      if (state is AddProductError) {
                        const ScaffoldMessenger(
                          child: SnackBar(
                            content: Text('Add product error'),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AddProductLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ElevatedButton(
                        onPressed: () {
                          final model = ProductRequestModel(
                              title: titleController!.text,
                              price: int.parse(priceController!.text),
                              description: descriptionController!.text);
                          context
                              .read<AddProductBloc>()
                              .add(DoAddProductEvent(model: model));
                        },
                        child: const Text('Add'),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
