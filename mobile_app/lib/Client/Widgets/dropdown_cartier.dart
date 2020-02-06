import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Client/Providers/search_provider.dart';

class DropDownCartier extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DropDownCartierState();
}

class _DropDownCartierState extends State<DropDownCartier> {
  List<String> _locations = [
    'Manastur',
    'Iris',
    'Marasti',
    'Gheorgheni',
  ]; // Option 2
  String _selectedLocation; // Option 2

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: DropdownButton(
              hint: Text(
                'Alege un cartier',
              ), // Not necessary for Option 1
              value: _selectedLocation,
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
                provider.changeCartier(newValue);
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
              provider.changeCartier("");
            },
          )
        ],
      ),
    );
  }
}
