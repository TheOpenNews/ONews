import 'package:anynews/consts/Colors.dart';
import 'package:flutter/material.dart';

class CategoryFilterWidget extends StatefulWidget {
  CategoryFilterWidget({
    super.key,
    required this.tags,
    required this.onSelectCategory,
  });

  final List<String> tags;
  Function onSelectCategory = () {};

  @override
  State<CategoryFilterWidget> createState() => _CategoryFilterWidgetState();
}

class _CategoryFilterWidgetState extends State<CategoryFilterWidget> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...widget.tags
            .asMap()
            .entries
            .map(
              (entry) => GestureDetector(
                onTap: () {
                  if (selectedCategory != entry.key) {
                    setState(() {
                      selectedCategory = entry.key;
                    });
                    widget.onSelectCategory(widget.tags[entry.key]);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: selectedCategory == entry.key
                        ? CColors.lightBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.grey.withOpacity(0.1),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedCategory == entry.key
                          ? Colors.white
                          : Colors.black,
                      fontWeight: selectedCategory == entry.key
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
