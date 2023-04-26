import 'package:flutter/material.dart';

class SearchCountryDelegate extends SearchDelegate<Country> {
  final List<Country> countries;

  List<Country> _filter = [];

  SearchCountryDelegate(this.countries);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {
        close(context, const Country(''));
      },
      icon: const Icon(Icons.arrow_back),
    );
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (_, index) {
        return Container(
          color: Colors.amber,
          height: 50,
          child: Center(
            child: Text(_filter[index].name),
          ),
        );
        ListTile(
          title: Text(_filter[index].name),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _filter = countries.where((country) {
      return country.name.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (_, index) {
        return Container(
          color: Colors.amber,
          height: 150,
          child: Center(
            child: Text(_filter[index].name),
          ),
        );
      },
    );
  }
}

class Country {
  final String name;

  const Country(this.name);
}
