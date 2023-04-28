import 'package:flutter/material.dart';
import 'package:my_language_app/lib/route.lib.dart';

class ComponentSideBar extends StatelessWidget {
  const ComponentSideBar({Key? key}) : super(key: key);

  Color? getActiveBG(String? routeName, String itemRouteName) {
    return routeName == itemRouteName ? Colors.black26 : null;
  }

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Center(child: Text('My Language App')),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/study/plan"),
            child: ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Study Plan'),
              onTap: () {
                RouteLib(context).change(target: '/study/plan');
              },
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/word/add"),
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add New Word'),
              onTap: () {
                RouteLib(context).change(target: '/word/add');
              },
            ),
          ),
          Container(
            color: getActiveBG(routeName, "/word/list"),
            child: ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('List Words'),
              onTap: () {
                RouteLib(context).change(target: '/word/list');
              },
            ),
          ),
        ],
      ),
    );
  }
}
