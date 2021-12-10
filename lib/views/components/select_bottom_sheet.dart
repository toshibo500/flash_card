import 'package:flutter/material.dart';
import 'package:bottom_sheet/bottom_sheet.dart';

// class SelectBottomSheet extends StatelessWidget {
//   const SelectBottomSheet({Key? key, required this.items}) : super(key: key);
//   final Map items;

//   @override
//   Widget build(BuildContext context) {
//     List<ListTile> tiles = [];
//     items.forEach((key, value) {
//       tiles.add(ListTile(
//         title: Text(value),
//         onTap: () => Navigator.of(context).pop(key),
//       ));
//     });
//     return DraggableScrollableSheet(
//       initialChildSize: 0.5,
//       maxChildSize: 1,
//       minChildSize: 0.25,
//       expand: false,
//       builder: (BuildContext context, ScrollController scrollController) {
//         return Container(
//           child: ListView.builder(
//             controller: scrollController,
//             itemCount: 5,
//             itemBuilder: (BuildContext context, int index) {
//               return ListTile(title: Text('Item $index'));
//             },
//           ),
//         );
//       },
//     );

//     /* Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Container(
//           child: IconButton(
//               onPressed: () => Navigator.of(context).pop(),
//               icon: const Icon(Icons.close_rounded)),
//           padding: const EdgeInsets.all(0),
//           alignment: Alignment.centerRight,
//         ),
//         Column(children: tiles),
//       ],
//     );
//  */
//   }
// }

Future showSelectBottomSheet(
    {required BuildContext context, required Map<String, String> items}) {
  List<Widget> _children = [];
  items.forEach((key, value) {
    _children.add(ListTile(
      title: Text(value),
      onTap: () => Navigator.of(context).pop(key),
    ));
  });

  return showStickyFlexibleBottomSheet<void>(
    minHeight: 0,
    initHeight: 0.5,
    maxHeight: .9,
    headerHeight: 50,
    context: context,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    headerBuilder: (context, offset) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(offset == 1.0 ? 0 : 10),
            topRight: Radius.circular(offset == 1.0 ? 0 : 10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded))),
            ),
          ],
        ),
      );
    },
    bodyBuilder: (context, offset) {
      return SliverChildListDelegate(
        _children,
      );
    },
    anchors: [.2, 0.5, .8],
  );
}
