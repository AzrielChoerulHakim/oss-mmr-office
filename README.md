# OSS MMR Office

Sistem administrasi internal sederhana untuk Mohammad Muchsin & Rekan.

## Scope V1

- Login untuk 2 pengguna
- Dashboard
- Surat Masuk
- Surat Keluar
- Jadwal Pak Muchsin
- Download Surat Masuk ke Excel
- Download Surat Keluar ke Excel

## Format Register

Export Excel mengikuti struktur register administrasi kantor:

### Surat Masuk
No | Tanggal Terima | Terima dari | Tanggal dan No. Surat | Perihal | Dit. Kpd. | Lamp | Kode

### Surat Keluar
No | Tanggal | Nomor Surat | Dari | Diterima | Kepada | Perihal | Lampiran | Kode

Tanggal surat dan nomor surat tetap disimpan terpisah di database agar mudah dicari/filter, lalu dapat digabung secara visual pada output Excel.

## Tidak termasuk V1

- Upload/penyimpanan file surat
- Case management
- Client management
- Billing
- AI
- Notifikasi
- Multi-role kompleks

## Stack

- React + Vite
- Tailwind CSS
- Supabase (Auth + PostgreSQL)
- SheetJS / XLSX untuk export
- Vercel untuk deployment
- GitHub untuk source code
