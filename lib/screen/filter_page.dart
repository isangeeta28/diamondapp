
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/diamond_filter_bloc.dart';
import '../model/filter_params.dart';
import 'result_page.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final _caratFromController = TextEditingController();
  final _caratToController = TextEditingController();
  String? _selectedLab;
  String? _selectedShape;
  String? _selectedColor;
  String? _selectedClarity;

  @override
  void initState() {
    super.initState();
    context.read<FilterBloc>().add(InitFilterOptionsEvent());
  }

  @override
  void dispose() {
    _caratFromController.dispose();
    _caratToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diamond Filter'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, state) {
          if (state.filterOptions.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter Diamonds',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 16.0),

                        // Carat range
                        Text(
                          'Carat Range',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _caratFromController,
                                decoration: InputDecoration(
                                  labelText: 'From',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: TextField(
                                controller: _caratToController,
                                decoration: InputDecoration(
                                  labelText: 'To',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),

                        // Lab dropdown
                        Text(
                          'Lab',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8.0),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedLab,
                          hint: Text('Select Lab'),
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: '',
                              child: Text('All Labs'),
                            ),
                            ...state.filterOptions['labs']!.map((lab) =>
                                DropdownMenuItem(
                                  value: lab,
                                  child: Text(lab),
                                )
                            ).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedLab = value == '' ? null : value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),

                        // Shape dropdown
                        Text(
                          'Shape',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8.0),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedShape,
                          hint: Text('Select Shape'),
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: '',
                              child: Text('All Shapes'),
                            ),
                            ...state.filterOptions['shapes']!.map((shape) =>
                                DropdownMenuItem(
                                  value: shape,
                                  child: Text(shape),
                                )
                            ).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedShape = value == '' ? null : value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),

                        // Color dropdown
                        Text(
                          'Color',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8.0),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedColor,
                          hint: Text('Select Color'),
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: '',
                              child: Text('All Colors'),
                            ),
                            ...state.filterOptions['colors']!.map((color) =>
                                DropdownMenuItem(
                                  value: color,
                                  child: Text(color),
                                )
                            ).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedColor = value == '' ? null : value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),

                        // Clarity dropdown
                        Text(
                          'Clarity',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8.0),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedClarity,
                          hint: Text('Select Clarity'),
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: '',
                              child: Text('All Clarities'),
                            ),
                            ...state.filterOptions['clarities']!.map((clarity) =>
                                DropdownMenuItem(
                                  value: clarity,
                                  child: Text(clarity),
                                )
                            ).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedClarity = value == '' ? null : value;
                            });
                          },
                        ),
                        SizedBox(height: 24.0),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Reset all filters
                                  setState(() {
                                    _caratFromController.clear();
                                    _caratToController.clear();
                                    _selectedLab = null;
                                    _selectedShape = null;
                                    _selectedColor = null;
                                    _selectedClarity = null;
                                  });

                                  context.read<FilterBloc>().add(ResetFilterEvent());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                child: Text('Reset'),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Apply filters and navigate to results
                                  final params = FilterParams(
                                    caratFrom: _caratFromController.text.isNotEmpty
                                        ? double.tryParse(_caratFromController.text)
                                        : null,
                                    caratTo: _caratToController.text.isNotEmpty
                                        ? double.tryParse(_caratToController.text)
                                        : null,
                                    lab: _selectedLab,
                                    shape: _selectedShape,
                                    color: _selectedColor,
                                    clarity: _selectedClarity,
                                  );

                                  context.read<FilterBloc>().add(UpdateFilterEvent(params));

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResultPage(filterParams: params),
                                    ),
                                  );
                                },
                                child: Text('Search'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}