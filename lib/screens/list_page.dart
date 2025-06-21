import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:rumah_sakit_app/model/rumah_sakit_model.dart';
import 'package:rumah_sakit_app/screens/detail_page.dart';
import 'package:rumah_sakit_app/screens/form_page.dart';
import 'package:rumah_sakit_app/services/api_service.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<RumahSakit>> rumahSakitList;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    setState(() {
      rumahSakitList = ApiService.fetchAll();
    });
  }

  void _showFlushBar(String message, {bool success = true}) {
    Flushbar(
      message: message,
      backgroundColor: success ? Colors.teal : Colors.red,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      icon: Icon(
        success ? Icons.check_circle : Icons.error,
        color: Colors.white,
      ),
    ).show(context);
  }

  void _showDeleteConfirmation(RumahSakit rs) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Rumah Sakit'),
        content: Text('Yakin ingin menghapus "${rs.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ApiService.delete(rs.id!);
      refreshData();
      _showFlushBar('Data "${rs.nama}" berhasil dihapus');
    }
  }

  Widget _buildItem(RumahSakit rs) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(Icons.local_hospital, color: Colors.white),
        ),
        title: Text(
          rs.nama,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tipe: ${rs.tipe}'),
              Text('Telepon: ${rs.telepon}'),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(rs.id!, refresh: refreshData),
            ),
          );
        },
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.indigo),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FormPage(rumahSakit: rs)),
                );
                if (result == true) {
                  refreshData();
                  _showFlushBar('Perubahan berhasil disimpan');
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _showDeleteConfirmation(rs),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text('Daftar Rumah Sakit'),
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
        child: FutureBuilder<List<RumahSakit>>(
          future: rumahSakitList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Gagal memuat data', style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Data rumah sakit kosong', style: TextStyle(color: Colors.white)));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80, top: 12),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => _buildItem(snapshot.data![index]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPage()),
          );
          if (result == true) {
            refreshData();
            _showFlushBar('Rumah sakit berhasil ditambahkan');
          }
        },
        child: const Icon(Icons.add, color: Colors.teal),
      ),
    );
  }
}