import 'package:flutter/material.dart';
import 'package:rumah_sakit_app/model/rumah_sakit_model.dart';
import 'package:rumah_sakit_app/services/api_service.dart';


class FormPage extends StatefulWidget {
  final RumahSakit? rumahSakit;

  const FormPage({super.key, this.rumahSakit});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _teleponController;
  late TextEditingController _tipeController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.rumahSakit?.nama ?? '');
    _alamatController = TextEditingController(text: widget.rumahSakit?.alamat ?? '');
    _teleponController = TextEditingController(text: widget.rumahSakit?.telepon ?? '');
    _tipeController = TextEditingController(text: widget.rumahSakit?.tipe ?? '');
    _latitudeController = TextEditingController(text: widget.rumahSakit?.latitude.toString() ?? '');
    _longitudeController = TextEditingController(text: widget.rumahSakit?.longitude.toString() ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    _tipeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final rs = RumahSakit(
        nama: _namaController.text,
        alamat: _alamatController.text,
        telepon: _teleponController.text,
        tipe: _tipeController.text,
        latitude: double.tryParse(_latitudeController.text) ?? 0.0,
        longitude: double.tryParse(_longitudeController.text) ?? 0.0,
      );

      if (widget.rumahSakit == null) {
        await ApiService.create(rs);
      } else {
        await ApiService.update(widget.rumahSakit!.id!, rs);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.rumahSakit != null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Rumah Sakit' : 'Tambah Rumah Sakit'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.local_hospital, color: Colors.teal, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      isEdit ? 'Edit Data Rumah Sakit' : 'Form Tambah Rumah Sakit',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_namaController, 'Nama Rumah Sakit'),
                  _buildTextField(_alamatController, 'Alamat'),
                  _buildTextField(_teleponController, 'No Telepon'),
                  _buildTextField(_tipeController, 'Tipe Rumah Sakit'),
                  _buildTextField(_latitudeController, 'Latitude', isNumber: true),
                  _buildTextField(_longitudeController, 'Longitude', isNumber: true),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: Icon(isEdit ? Icons.save : Icons.add),
                      label: Text(isEdit ? 'Simpan Perubahan' : 'Tambah'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.teal),
          prefixIcon: _getIconForLabel(label),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }

  Icon _getIconForLabel(String label) {
    if (label.contains('Nama')) return const Icon(Icons.local_hospital);
    if (label.contains('Alamat')) return const Icon(Icons.location_on);
    if (label.contains('Telepon')) return const Icon(Icons.phone);
    if (label.contains('Tipe')) return const Icon(Icons.category);
    if (label.contains('Latitude')) return const Icon(Icons.my_location);
    if (label.contains('Longitude')) return const Icon(Icons.navigation);
    return const Icon(Icons.edit);
  }
}