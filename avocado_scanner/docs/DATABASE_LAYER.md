# Database Layer - Documentation

## 📊 Tahap 4: Database Layer (SQLite) - ✅ SELESAI

Implementasi lengkap database layer menggunakan SQLite dengan Sqflite.

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────┐
│      Presentation Layer (Providers)     │
│         (akan dibuat di Tahap 7)        │
└──────────────┬──────────────────────────┘
               │
┌──────────────┴──────────────────────────┐
│      Domain Layer (Repositories)        │
│  - ScanRepository (abstract)            │
│  - HistoryRepository (abstract)         │
└──────────────┬──────────────────────────┘
               │
┌──────────────┴──────────────────────────┐
│      Data Layer (Implementation)        │
│  - ScanRepositoryImpl                   │
│  - DatabaseHelper (singleton)           │
│  - ScanHistoryDao (DAO)                 │
│  - DatabaseService (singleton)          │
│  - DbSchema (constants)                 │
└──────────────┬──────────────────────────┘
               │
┌──────────────┴──────────────────────────┐
│      SQLite Database Layer              │
│  - scan_history table                   │
│  - Indexes (date, class, confidence)    │
└─────────────────────────────────────────┘
```

---

## 📁 Files Created

### 1. **db_schema.dart** - Database Schema
- Database name & version constants
- Table names & column definitions
- SQL CREATE TABLE statements
- Index creation scripts
- Schema helper methods

```dart
// Example usage
DbSchema.databaseName        // 'avocado_scanner.db'
DbSchema.tableScanHistory    // 'scan_history'
DbSchema.colScanDate         // 'scan_date'
DbSchema.getCreationScripts() // All SQL scripts
```

### 2. **database_service.dart** - Singleton Database Service
- Manages SQLite database connection
- Handles initialization & migrations
- onCreate, onUpgrade, onDowngrade callbacks
- Database lifecycle management

**Key Methods:**
```dart
// Singleton instance
DatabaseService.instance

// Get database
final db = await DatabaseService.instance.database

// Close database
await DatabaseService.instance.close()

// Get database info
await DatabaseService.instance.getDatabaseInfo()

// Delete database
await DatabaseService.instance.deleteDatabase()
```

### 3. **scan_history_dao.dart** - Data Access Object
Complete CRUD operations for scan_history table:

**Create:**
```dart
final dao = ScanHistoryDao();
final id = await dao.insertScanResult(scanResultModel);
```

**Read:**
```dart
// By ID
final result = await dao.getScanResultById(1);

// All results
final allResults = await dao.getAllScanResults();

// Paginated
final paginated = await dao.getScanResultsPaginated(limit: 20, offset: 0);

// By class
final byClass = await dao.getScanResultsByClass('Matang');

// By confidence
final byConf = await dao.getScanResultsByConfidence(
  minConfidence: 0.7,
  maxConfidence: 0.95,
);

// By date range
final byDate = await dao.getScanResultsByDateRange(
  startDate: startDate,
  endDate: endDate,
);

// Most recent
final recent = await dao.getMostRecentScanResult();

// Statistics
final stats = await dao.getStatistics();
```

**Update:**
```dart
final updated = await dao.updateScanResult(scanResultModel);
```

**Delete:**
```dart
// Single
await dao.deleteScanResultById(1);

// Multiple
await dao.deleteScanResultsByIds([1, 2, 3]);

// All (use with caution!)
await dao.deleteAllScanResults();

// Clear old (keep recent N)
await dao.clearOldScanResults(keepCount: 100);
```

### 4. **database_helper.dart** - Database Helper
High-level helper functions:

```dart
// Singleton
DatabaseHelper.instance

// Initialize
await DatabaseHelper.instance.initialize();

// Get statistics
final stats = await DatabaseHelper.instance.getStatistics();

// Reset database
await DatabaseHelper.instance.resetDatabase();

// Health check
final isHealthy = await DatabaseHelper.instance.healthCheck();

// Export statistics
final export = await DatabaseHelper.instance.exportStatistics();

// Clear cache (keep recent N)
await DatabaseHelper.instance.clearCache(keepRecent: 100);
```

### 5. **scan_repository.dart** - Abstract Repository
Domain layer repository interface:

```dart
abstract class ScanRepository {
  // Scanning
  Future<ScanResult> performScan(List<int> imageBytes, String imagePath);
  
  // CRUD
  Future<int> saveScanResult(ScanResult scanResult);
  Future<ScanResult?> getScanResultById(int id);
  Future<List<ScanResult>> getAllScanResults();
  
  // Filtering
  Future<List<ScanResult>> getScanResultsByClass(String ripenessClass);
  Future<List<ScanResult>> getScanResultsByConfidence({...});
  Future<List<ScanResult>> getScanResultsByDateRange({...});
  
  // Pagination
  Future<List<ScanResult>> getScanResultsPaginated({...});
  
  // Deletion
  Future<int> deleteScanResult(int id);
  Future<int> deleteAllScanResults();
  
  // Statistics
  Future<Map<String, dynamic>> getStatistics();
}
```

### 6. **scan_repository_impl.dart** - Concrete Repository
Implementation dengan database integration:

```dart
final repo = ScanRepositoryImpl();

// Save scan result
final id = await repo.saveScanResult(scanResult);

// Get by id
final result = await repo.getScanResultById(id);

// Get filtered results
final results = await repo.getScanResultsByClass('Matang');

// Statistics
final stats = await repo.getStatistics();
```

---

## 💾 Database Schema

### scan_history Table

| Column | Type | Notes |
|--------|------|-------|
| `id` | INTEGER PRIMARY KEY | Auto-increment |
| `scan_date` | TEXT | ISO 8601 datetime |
| `image_path` | TEXT | Local file path |
| `image_blob` | BLOB | Optional image data |
| `detections` | TEXT | JSON array |
| `main_class` | TEXT | Ripeness class |
| `main_confidence` | REAL | 0.0-1.0 |
| `inference_time_ms` | INTEGER | Milliseconds |
| `image_width` | INTEGER | Image width |
| `image_height` | INTEGER | Image height |
| `fps` | REAL | Frames per second |
| `notes` | TEXT | Optional notes |
| `created_at` | TIMESTAMP | Created datetime |

### Indexes

- `idx_scan_date` - Query recent scans efficiently
- `idx_main_class` - Filter by ripeness class
- `idx_main_confidence` - Sort by confidence

---

## 🔄 Data Flow

```
┌─────────────────┐
│  ScanResult     │  (Domain Entity)
│  (from ML)      │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────┐
│  ScanResultModel.fromEntity │  (Convert to model)
└────────┬────────────────────┘
         │
         ▼
┌───────────────────────────────────────┐
│  ScanRepositoryImpl.saveScanResult    │
└────────┬────────────────────────────┬─┘
         │                            │
         ▼                            ▼
    ┌─────────────┐           ┌──────────────────┐
    │  DatabaseHelper         │ ScanHistoryDao   │
    │  (High-level)           │ (Low-level DAO)  │
    └─────────────┘           └──────────────────┘
         │                            │
         └────────────┬───────────────┘
                      │
                      ▼
         ┌────────────────────────┐
         │  DatabaseService       │
         │  (SQLite Connection)   │
         └────────────────────────┘
                      │
                      ▼
         ┌────────────────────────┐
         │  SQLite Database       │
         │  (scan_history table)  │
         └────────────────────────┘
```

---

## 🛠️ Usage Examples

### Initialize Database

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseHelper.instance.initialize();
  
  runApp(const MyApp());
}
```

### Save Scan Result

```dart
// Create scan result
final scanResult = ScanResult(
  scanDate: DateTime.now(),
  imagePath: '/path/to/image.jpg',
  detections: [detection1, detection2],
  mainClass: AvocadoClass.matang,
  mainConfidence: 0.95,
  inferenceTimeMs: 150,
  imageWidth: 640,
  imageHeight: 480,
);

// Save to database
final repo = ScanRepositoryImpl();
final id = await repo.saveScanResult(scanResult);
print('Saved with id: $id');
```

### Query Scan Results

```dart
final repo = ScanRepositoryImpl();

// Get all
final all = await repo.getAllScanResults();

// Get paginated
final page1 = await repo.getScanResultsPaginated(limit: 20, offset: 0);

// Filter by class
final ripe = await repo.getScanResultsByClass('Matang');

// Filter by confidence
final highConf = await repo.getScanResultsByConfidence(minConfidence: 0.8);

// Get most recent
final recent = await repo.getMostRecentScanResult();
```

### Statistics & Analytics

```dart
final repo = ScanRepositoryImpl();

// Get statistics
final stats = await repo.getStatistics();
print('Total: ${stats['totalRecords']}');
print('Avg Confidence: ${stats['averageConfidence']}%');
print('Distribution: ${stats['classDistribution']}');

// Get database info
final helper = DatabaseHelper.instance;
final info = await helper.getDatabaseInfo();
print('Database path: ${info['path']}');
print('Table count: ${info['tables']}');
```

### Maintenance Operations

```dart
final helper = DatabaseHelper.instance;

// Health check
final isHealthy = await helper.healthCheck();

// Clear cache (keep recent 100)
await helper.clearCache(keepRecent: 100);

// Export statistics
final export = await helper.exportStatistics();
print(export);

// Reset database (delete all)
await helper.resetDatabase();

// Close database
await helper.close();
```

---

## 📈 Performance Considerations

### Indexes
- ✅ Created for frequent queries
- ✅ `scan_date` DESC for recent scans
- ✅ `main_class` for filtering
- ✅ `main_confidence` for sorting

### Pagination
- ✅ Use `getScanResultsPaginated()` for large datasets
- ✅ Default limit: 20 items per page
- ✅ Prevents memory issues

### Caching
- ✅ `clearOldScanResults()` removes old data
- ✅ Keep configurable number of recent items
- ✅ Example: Keep only last 100 scans

### Batch Operations
- ✅ `deleteScanResultsByIds()` for bulk delete
- ✅ More efficient than deleting one by one

---

## 🧪 Testing

### Unit Test Example

```dart
test('Insert and retrieve scan result', () async {
  final dao = ScanHistoryDao();
  
  // Create model
  final model = ScanResultModel(
    scanDate: '2024-01-01T00:00:00',
    imagePath: '/test/image.jpg',
    detections: [],
    mainClass: 'Matang',
    mainConfidence: 0.95,
    inferenceTimeMs: 150,
    imageWidth: 640,
    imageHeight: 480,
  );
  
  // Insert
  final id = await dao.insertScanResult(model);
  expect(id, isNotNull);
  
  // Retrieve
  final retrieved = await dao.getScanResultById(id);
  expect(retrieved, isNotNull);
  expect(retrieved?.mainConfidence, 0.95);
});
```

---

## ⚠️ Important Notes

1. **Singleton Pattern**: `DatabaseService` dan `DatabaseHelper` menggunakan singleton
2. **Async/Await**: Semua database operations adalah async
3. **Error Handling**: Semua methods memiliki try-catch dan logging
4. **Migrations**: Support untuk future database upgrades
5. **Backup**: Implementasi backup sudah ready di next tahap

---

## 🚀 Tahap Berikutnya

### TAHAP 5: ML Services Pipeline
- [ ] TFLite service wrapper
- [ ] Image preprocessing
- [ ] NMS (Non-Maximum Suppression)
- [ ] Model loading & caching

Database layer siap untuk menerima hasil inference dari ML service!

---

## 📊 Summary Statistics

| Item | Count |
|------|-------|
| Files Created | 6 |
| Total LOC | 1,200+ |
| DAO Methods | 15+ |
| SQL Queries | 10+ |
| Error Handling | ✅ Complete |
| Logging | ✅ Complete |
| Comments | ✅ Extensive |

---

**Status**: ✅ **DATABASE LAYER COMPLETE**
**Next Phase**: ML Services Implementation
