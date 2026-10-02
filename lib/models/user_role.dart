enum UserRole {
  pencariKost,
  pemilikKost,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.pencariKost:
        return 'Pencari Kost';
      case UserRole.pemilikKost:
        return 'Pemilik Kost';
    }
  }

  String get description {
    switch (this) {
      case UserRole.pencariKost:
        return 'Cari & pesan tempat tinggal impianmu';
      case UserRole.pemilikKost:
        return 'Kelola & tawarkan katalog kost milikmu';
    }
  }
}
