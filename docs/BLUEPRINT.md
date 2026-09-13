# OSS MMR Office — Blueprint V1

## Navigasi

- Dashboard
- Surat Masuk
- Surat Keluar
- Jadwal Pak Muchsin

## Authentication

Hanya 2 akun internal. Tidak ada public registration. Kedua akun memiliki akses aplikasi yang sama.

## Surat Masuk

Fields:
- id
- tanggal_terima
- terima_dari
- tanggal_surat
- nomor_surat
- perihal
- ditujukan_kepada
- lampiran
- kode
- created_at
- updated_at

Export:
No | Tanggal Terima | Terima dari | Tanggal dan No. Surat | Perihal | Dit. Kpd. | Lamp | Kode

Tanggal surat dan nomor surat tetap terpisah di database, lalu digabung secara visual pada export.

## Surat Keluar

Fields:
- id
- tanggal
- nomor_surat
- dari
- diterima
- kepada
- perihal
- lampiran
- kode
- created_at
- updated_at

Export:
No | Tanggal | Nomor Surat | Dari | Diterima | Kepada | Perihal | Lampiran | Kode

## Jadwal Pak Muchsin

Fields:
- id
- tanggal
- jam
- kegiatan
- lokasi
- keterangan
- created_at
- updated_at

Tidak ada export khusus jadwal pada V1.

## Database

- profiles
- incoming_letters
- outgoing_letters
- schedules

## Security

Gunakan Supabase Auth dan Row Level Security (RLS). Tidak ada public registration.

## Register Number

Nomor urut register bersifat permanen dan tidak renumber saat data lain dihapus.

## Prinsip

UI aplikasi ringkas dan nyaman digunakan. Output Excel mengikuti format register administrasi kantor. Tidak menyimpan/upload bentuk atau file surat.
