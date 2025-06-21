
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rumah_sakit_app/model/rumah_sakit_model.dart';
import 'package:rumah_sakit_app/services/api_service.dart';


class DetailPage extends StatelessWidget {
  final int id;
  final VoidCallback refresh;

  const DetailPage(this.id, {super.key, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text('Detail Rumah Sakit'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<RumahSakit>(
          future: ApiService.fetchDetail(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
                    const SizedBox(height: 10),
                    const Text('Gagal memuat detail', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal,
                      ),
                      onPressed: refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            final rs = snapshot.data!;
            final validLatLng = rs.latitude != 0 && rs.longitude != 0;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Informasi RS
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rs.nama,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 1.2),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.location_on, rs.alamat),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.phone, rs.telepon),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.local_hospital, rs.tipe),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Peta Lokasi
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.teal[100],
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.map, color: Colors.teal),
                            SizedBox(width: 8),
                            Text(
                              'Peta Lokasi Rumah Sakit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                        child: SizedBox(
                          height: 250,
                          child: validLatLng
                              ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(rs.latitude, rs.longitude),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('rumah_sakit'),
                                position: LatLng(rs.latitude, rs.longitude),
                                infoWindow: InfoWindow(title: rs.nama),
                              ),
                            },
                            zoomControlsEnabled: false,
                          )
                              : Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Text('Lokasi tidak tersedia'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.teal),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
