import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ble/Services/CRUD/crud_exception.dart';
import 'package:ble/Material/constants.dart';
import 'package:ble/classes/Professor.dart';
import 'package:ble/classes/Student.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

class StrorageService {
  Database? _db;

  static final StrorageService _shared = StrorageService._sharedInstance();
  StrorageService._sharedInstance();
  factory StrorageService() => _shared;

  String generateSalt([int length = 16]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final hashed = sha256.convert(bytes);
    return hashed.toString();
  }

  Future<int> editProf(
      {required String id, required Professor professor}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    return await db.update(
      dbProf,
      professor.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> addProf(Professor professor) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final salt = generateSalt();
    final saltedPassword = hashPassword(professor.password!, salt);

    // Store the hashed password and salt
    int result = await db.insert(
      dbProf,
      {
        ...professor.toMap(),
        'password': saltedPassword,
        'salt': salt, // Add the salt as a new column
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return (result > 0);
  }

  Future<bool> addStudent(Student student) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // Generate salt and hash the password
    final salt = generateSalt();
    final saltedPassword = hashPassword(student.password!, salt);

    // Store the hashed password and salt
    int result = await db.insert(
      dbStudent,
      {
        ...student.toMap(),
        'password': saltedPassword,
        'salt': salt, // Add the salt as a new column
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return (result > 0);
  }

  Future<Professor?> loginProf(String profId, String password) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // Retrieve the stored hashed password and salt
    final result = await db.query(
      dbProf,
      where: 'id = ?',
      whereArgs: [profId],
    );

    if (result.isNotEmpty) {
      dev.log('huuuuuuuuh');
      Professor professor = Professor.fromRow(result.first);
      final storedHash = result.first['password'] as String;
      final salt = result.first['salt'] as String;

      // Hash the provided password with the retrieved salt
      final saltedPassword = hashPassword(password, salt);

      // Compare the stored hash with the new hash
      if (storedHash == saltedPassword) {
        return professor;
      }
    }
    return null; // Login failed
  }

  Future<Student?> loginStudent(String id, String password) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // Retrieve the stored hashed password and salt
    final result = await db.query(
      dbStudent,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      dev.log(result.first.toString());
      final student = Student.fromRow(result.first);
      final storedHash = result.first['password'] as String;
      final salt = result.first['salt'] as String;

      // Hash the provided password with the retrieved salt
      final saltedPassword = hashPassword(password, salt);

      // Compare the stored hash with the new hash
      if (storedHash == saltedPassword) {
        return student;
      }
    }
    return null; // Login failed
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // create the professor table
      await db.execute(createProfessorTable);

      // create the strudent table
      await db.execute(createStudentTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    } catch (e) {
      dev.log("$e", name: "table creation");
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }
}
