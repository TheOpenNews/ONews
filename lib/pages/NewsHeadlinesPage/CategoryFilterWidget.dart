import 'package:onews/consts/Colors.dart';
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      
      child: Row(
        
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ... widget.tags
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
                    padding: EdgeInsets.symmetric(horizontal:  10, vertical: 8),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: selectedCategory == entry.key
                          ? CColors.primaryBlue
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.grey.withOpacity(0.3),
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
                            fontVariations: [FontVariation("wght", 500)]
                      ),
                    ),
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
