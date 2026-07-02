import 'models.dart';

const List<Prayer> kPrayers = [
  Prayer(id: 'fajr', name: 'Fajr', rakah: 2, timeOfDay: 'dawn'),
  Prayer(id: 'dhuhr', name: 'Dhuhr', rakah: 4, timeOfDay: 'midday'),
  Prayer(id: 'asr', name: 'Asr', rakah: 4, timeOfDay: 'afternoon'),
  Prayer(id: 'maghrib', name: 'Maghrib', rakah: 3, timeOfDay: 'sunset'),
  Prayer(id: 'isha', name: 'Isha', rakah: 4, timeOfDay: 'night'),
];

Prayer prayerById(String id) => kPrayers.firstWhere((p) => p.id == id);
