package com.abhibhut.Utils;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class SqlUtils extends SQLiteOpenHelper {

    private static final String DATABASE_NAME = "com.abhibhut.abhibhut_db.db";
    private static final int DATABASE_VERSION = 1;

    // Singleton instance
    private static SqlUtils instance;

    // Private constructor to prevent direct instantiation
    private SqlUtils(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    // Singleton getInstance method
    public static synchronized SqlUtils getInstance(Context context) {
        if (instance == null) {
            instance = new SqlUtils(context.getApplicationContext());
        }
        return instance;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        // tables are already created in Flutter
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // handeled in Flutter
    }
}
