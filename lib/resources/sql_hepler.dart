import 'package:flutter/material.dart';
import 'package:flutter_movie/models/item.dart';
import 'package:flutter_movie/models/movie.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static const nameDb = 'manga_app.db';
  static const itemsTable = 'items';
  static const createItemsTable =
      'CREATE TABLE items (id INTEGER PRIMARY KEY NOT NULL, title TEXT, poster_path TEXT, backdrop_path TEXT, overview TEXT, release_date TEXT, vote_average TEXT, create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)';

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      nameDb,
      version: 1,
      onCreate: (db, version) async {
        await createItemTables(db);
      },
    );
  }

  static Future<void> createItemTables(sql.Database database) async {
    await database.execute(createItemsTable);
  }

  static Future<int> createItem({
    title,
    posterPath,
    backdropPath,
    description,
    releaseDate,
    voteAverage,
    movieId,
  }) async {
    final db = await SQLHelper.db();

    final newsId = await db.insert(
      itemsTable,
      {
        'id': movieId,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'overview': description,
        'release_date': releaseDate,
        'vote_average': voteAverage,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return newsId;
  }

  static Future<List<Item>> getItems() async {
    final db = await SQLHelper.db();
    final listItems = await db.query(itemsTable);
    return listItems.map((e) => Item.fromJson(e)).toList();
  }

  static Future<Item?> getItem(int id) async {
    final db = await SQLHelper.db();
    final listItems =
        await db.query(itemsTable, where: 'id=?', whereArgs: [id]);

    return listItems.isNotEmpty ? Item.fromJson(listItems.first) : null;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(
        itemsTable,
        where: 'id=?',
        whereArgs: [id],
      );
    } catch (error) {
      debugPrint('Some thing error');
    }
  }
}
