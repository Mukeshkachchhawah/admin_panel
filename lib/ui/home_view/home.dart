import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_admin_panal/ui/curd_opration/add_product_view.dart';
import 'package:user_admin_panal/utils/ui_helper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance; // Firebase initialize
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Admin Panel"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('product').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            final productData = snapshot.data!.docs;
            return ListView.builder(
              itemCount: productData.length,
              itemBuilder: (context, index) {
                final product = productData[index];
                final imageUrl = product['image'];
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  child: SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Title : ${product['name']}"),
                                    hSpace(),
                                    Text("Desc : ${product['description']}"),
                                    hSpace(),
                                    Text("Price : ${product['amount']}"),
                                  ],
                                ),
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16),
                                    /*  image: DecorationImage(
                                          image: (imageUrl != null &&
                                                  Uri.tryParse(imageUrl)
                                                          ?.hasAbsolutePath ==
                                                      true)
                                              ? NetworkImage(imageUrl)
                                              : AssetImage(
                                                      'assets/placeholder.png')
                                                  as ImageProvider,
                                          fit: BoxFit.cover) */
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                height: 50,
                                child: OutlinedButton(
                                    onPressed: () {},
                                    child: const Text("Update")),
                              )),
                              wSpace(),
                              Expanded(
                                  child: SizedBox(
                                height: 50,
                                child: OutlinedButton(
                                    onPressed: () {},
                                    child: const Text("Delete")),
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        width: 200,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductView(),
                ));
          },
          child: const Text("Add Product"),
        ),
      ),
    );
  }
}
