import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssignDriverDialog extends StatefulWidget {
  final int orderId;
  final VoidCallback onDriverAssigned;

  const AssignDriverDialog({
    Key? key,
    required this.orderId,
    required this.onDriverAssigned,
  }) : super(key: key);

  @override
  _AssignDriverDialogState createState() => _AssignDriverDialogState();
}

class _AssignDriverDialogState extends State<AssignDriverDialog> {
  List<dynamic> _drivers = [];
  int? _selectedDriverId;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/drivers'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _drivers = data['data'] ?? []; // Adapté à la nouvelle structure de réponse
          _isLoading = false;
        });
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Assigner un livreur'),
      content: SizedBox(
        width: double.maxFinite,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Text(_errorMessage!)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Sélectionnez un livreur:'),
                      const SizedBox(height: 16),
                      if (_drivers.isEmpty)
                        const Text('Aucun livreur disponible',
                            style: TextStyle(color: Colors.red))
                      else
                      DropdownButtonFormField<int>(
                        value: _selectedDriverId,
                        items: _drivers.map((driver) {
                          return DropdownMenuItem<int>(
                            value: driver['id'] as int, // Cast explicite en int
                            child: Text(driver['name']),
                          );
                        }).toList(),
                        onChanged: (int? value) { // Type explicitement défini
                          setState(() {
                            _selectedDriverId = value;
                          });
                        },

                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        ),
                    ],
                  ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _selectedDriverId == null || _drivers.isEmpty
              ? null
              : () async {
                  try {
                    final response = await http.post(
                      Uri.parse(
                          'http://10.0.2.2:8000/api/orders/${widget.orderId}/assign-driver'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'driver_id': _selectedDriverId}),
                    );

                    if (response.statusCode == 200) {
                      widget.onDriverAssigned();
                      Navigator.pop(context);
                    } else {
                      throw Exception('Échec de l\'assignation');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: ${e.toString()}')),
                    );
                  }
                },
          child: const Text('Assigner'),
        ),
      ],
    );
  }
}