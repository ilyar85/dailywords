import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'services/initialization_service.dart';

class CategoriesScreen extends StatefulWidget {
  final InitializationService initializationService;
  CategoriesScreen({required this.initializationService});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  InitializationService get _initializationService => widget.initializationService;

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Image.asset('assets/back.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 48.0,
                      horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('категории', style: TextStyle(fontSize: 41)),
                      SizedBox(height: 8),
                      Text(
                        'Для начала тестирования выберите 4 категории. \nВ разделе меню вы можете добавить дополнительные категории для изучения новых слов.',
                        style: TextStyle(color: Color(0xFF6F6F6F), fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Ошибка: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot category = snapshot.data!.docs[index];
                        String categoryName = category['topic'];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (selectedCategories.contains(categoryName)) {
                                  selectedCategories.remove(categoryName);
                                } else {
                                  selectedCategories.add(categoryName);
                                }
                              });
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Color(0xFF151515),
                                border: Border.all(
                                  color: selectedCategories.contains(categoryName)
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  categoryName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: selectedCategories.contains(categoryName)
                                        ? Color(0xFF003AFF)
                                        : Color(0xFF6F6F6F),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
                           SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedCategories.length == 4) {
                      // TODO: Сохраните выбранные категории для пользователя в Firestore
                      await _initializationService.saveUserCategories(selectedCategories);

                      // TODO: Переход на следующий экран
                      Navigator.pushNamed(context, '/home');
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Ошибка'),
                            content: Text('Выберите ровно 4 категории.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('ОК'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('продолжить'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF6F6F6F)),
                    minimumSize: MaterialStateProperty.all(Size(300, 50)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}