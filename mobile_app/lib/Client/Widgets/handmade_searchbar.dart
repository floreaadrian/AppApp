import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Client/Providers/search_provider.dart';
import 'package:sefii_flutter_x/Client/Widgets/firma_list_widget.dart';

GlobalKey _keySized = GlobalKey();

class HandMadeSearchBar extends StatefulWidget {
  HandMadeSearchBar({Key key}) : super(key: key);

  @override
  _HandMadeSearchBarState createState() => _HandMadeSearchBarState();
}

class _HandMadeSearchBarState extends State<HandMadeSearchBar> {
  List<String> dataAvalible = [];
  final myController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Widget foundWidgets() {
    final provider = Provider.of<SearchProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getData(),
      builder: (context, widgetSnap) {
        if (widgetSnap.connectionState == ConnectionState.done) {
          if (widgetSnap.data == null) return Container();
          return ListView.builder(
            itemCount: widgetSnap.data.length,
            itemBuilder: (context, index) {
              return FirmaListWidget(
                businessInfo: widgetSnap.data[index],
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    hintText: "Numele firmei",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                  onChanged: (text) {
                    provider.changeName(text);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    myController.clear();
                    provider.changeName("");
                  });
                },
              )
            ],
          ),
          SizedBox(
            key: _keySized,
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 300,
            child: foundWidgets(),
          )
        ],
      ),
    );
  }
}
