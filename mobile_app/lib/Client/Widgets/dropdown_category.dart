import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Client/Providers/search_provider.dart';

class DropDownCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DropDownCategoryState();
}

class _DropDownCategoryState extends State<DropDownCategory> {
  List<String> _locations = [
    'Dentist',
    'Doctor',
    'Restaurant',
  ]; // Option 2
  String _selectedLocation; // Option 2

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButton(
              hint: Text(
                'Alege o categorie',
              ), // Not necessary for Option 1
              value: _selectedLocation,
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
                provider.changeCategory(newValue);
              },
              items: _locations.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _selectedLocation = null;
              });
              provider.changeCategory("");
            },
          )
        ],
      ),
    );
  }
}
