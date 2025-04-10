import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mkadia/common/color_extension.dart';

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
          _drivers = data['data'] ?? [];
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Assigner un livreur',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: TColor.primaryText,
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  )
                : _errorMessage != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Column(
                        children: [
                          const Text(
                            'Sélectionnez un livreur pour cette commande',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (_drivers.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Aucun livreur disponible',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<int>(
                                value: _selectedDriverId,
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: _drivers.map((driver) {
                                  return DropdownMenuItem<int>(
                                    value: driver['id'] as int,
                                    child: Text(driver['name']),
                                  );
                                }).toList(),
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedDriverId = value;
                                  });
                                },
                                hint: Text('Choisir un livreur',style: TextStyle(color: TColor.primaryText),),
                              ),
                            ),
                        ],
                      ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Livreur assigné avec succès'),
                                  backgroundColor: TColor.primaryText,
                                ),
                              );
                            } else {
                              throw Exception('Échec de l\'assignation');
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erreur: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: const Text('Confirmer',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}