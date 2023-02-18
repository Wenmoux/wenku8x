import 'package:flutter/material.dart';
import 'package:wenku8x/modals/chapter.dart';
import 'package:wenku8x/views/reader/constants/theme.dart';

class MenuCatalog extends StatefulWidget {
  const MenuCatalog(
      {Key? key,
      // required this.visible,
      required this.currentIndex,
      required this.backgroundColor,
      required this.chapters,
      required this.onItemTap})
      : super(key: key);
  // final bool visible;
  final Color backgroundColor;
  final List<Chapter> chapters;
  final void Function(int index, Chapter chapter) onItemTap;
  final int currentIndex;

  @override
  State<MenuCatalog> createState() => MenuCatalogState();
}

class MenuCatalogState extends State<MenuCatalog> {
  late bool visible = false;
  @override
  void initState() {
    super.initState();
    // visible = widget.visible;
  }

  void open() {
    setState(() {
      visible = true;
    });
  }

  void close() {
    setState(() {
      visible = false;
    });
  }

  void toggle() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewPadding.bottom + 48,
      left: 0,
      child: Material(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: MediaQuery.of(context).size.width,
          height: visible
              ? MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).viewPadding.bottom + 48) -
                  (MediaQuery.of(context).viewPadding.top + 56)
              : 0,
          color: widget.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: Text(
                  "目录",
                  style: TextStyle(color: pannelTextColor, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                  child: MediaQuery.removePadding(
                      removeTop: true,
                      removeBottom: true,
                      context: context,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const SizedBox(
                                height: 1,
                              );
                            } else {
                              final chapter = widget.chapters[index - 1];
                              return InkWell(
                                onTap: () {
                                  widget.onItemTap(index - 1, chapter);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  child: Text(
                                    chapter.name,
                                    style: TextStyle(
                                        color: (index - 1) == widget.currentIndex ? primaryColor : pannelTextColor,
                                        fontSize: 13),
                                  ),
                                ),
                              );
                            }
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              indent: 16,
                              endIndent: 16,
                              height: 0,
                              thickness: 0.4,
                              color: dividerColor,
                            );
                          },
                          itemCount: widget.chapters.length + 1)))
            ],
          ),
        ),
      ),
    );
  }
}
