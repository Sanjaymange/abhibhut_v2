package com.domain_name.abhibhut;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;

import com.abhibhut.Utils.SqlUtils;


import java.io.ByteArrayOutputStream;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppData {

    Context context;

    public AppData(Context context)
    {
        this.context = context;
    }

    /*rename this file with the default file name of shared preference*/
    static final String PREF_FILE_NAME = "com.abhibhut.blocked_apps";
    public static List<Map<String, Object>> InstalledAppList(Context context) {

        PackageManager pkg_mgr = context.getPackageManager();

        List<Map<String, Object>> appList = new ArrayList<>();

        List<ApplicationInfo> appinfo = get_user_installed_apps(pkg_mgr);

        Map<String , Object> blocked_pkgs = getBlockedPkgs(context);

        for(ApplicationInfo appInfo : appinfo)
        {
            Map<String , Object> app_data = new HashMap<>();

            String package_nm = appInfo.packageName;
                app_data.put("app_name",pkg_mgr.getApplicationLabel(appInfo));
                app_data.put("icon", get_icon(pkg_mgr,package_nm));
                app_data.put("package_name",package_nm);


                /*Checking is app is blocked*/
                    if (blocked_pkgs.containsKey(package_nm)) {
                        List<Integer> times = (List<Integer>) blocked_pkgs.get(package_nm);
                        app_data.put("blocked_app", true);
                        app_data.put("start_time", times.get(0));
                        app_data.put("end_time", times.get(1));
                        app_data.put("app_id",blocked_pkgs.get("app_id"));
                    }
                else {
                    app_data.put("blocked_app", false);
                    app_data.put("start_time", null);
                    app_data.put("end_time", null);
                    appList.add(app_data);
                }
            }
            return  appList;
        }

    public static List<ApplicationInfo> get_user_installed_apps(PackageManager pkg_mgr)
    {
        List<ApplicationInfo> user_installed = new ArrayList<>();
        List<String> IncludedSystemApp = new ArrayList<>();
        IncludedSystemApp.add("com.android.chrome");
        IncludedSystemApp.add("com.google.android.youtube");
        List<ApplicationInfo> apps = pkg_mgr.getInstalledApplications(0);
        for (ApplicationInfo appInfo : apps) {
            boolean isSystemApp = ((appInfo.flags & ApplicationInfo.FLAG_SYSTEM) != 0);
            String packageName = appInfo.packageName;

            if ((!isSystemApp || IncludedSystemApp.contains(packageName)))
            {
                user_installed.add(appInfo);
            }
        }
        return user_installed;
    }

    public static Map<String , Object> getBlockedPkgs(Context context)
    {
        Map<String , Object> blocked_apps = new HashMap<>();
        SqlUtils dbHelper = SqlUtils.getInstance(context);
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        String[] selectionArgs = {"true"};
        Cursor data = db.rawQuery("SELECT APP_ID, PACKAGE_NM , START_TIME , END_TIME FROM APP_DATA WHERE BLOCKED = ?",selectionArgs);
        while(data.moveToNext())
        {
            blocked_apps.put("app_id",data.getInt(0));
            List<Integer> times = new ArrayList<>();
            String package_name = data.getString(1);
            //start_time
            times.add(data.getInt(2));
            //end_time
            times.add(data.getInt(3));
            blocked_apps.put(package_name,times);
        }
        return blocked_apps;
    }

    public static byte[] get_icon(PackageManager pkg_mgr , String Pkg_nm) {
        Drawable appIcon = null;
        try {
            appIcon = pkg_mgr.getApplicationIcon(Pkg_nm);
        } catch (PackageManager.NameNotFoundException e) {
                return new byte[0];
        }
        Bitmap appIconBitmap;
        if (appIcon instanceof BitmapDrawable) {
            appIconBitmap = ((BitmapDrawable) appIcon).getBitmap();
        } else {
            int width = appIcon.getIntrinsicWidth();
            int height = appIcon.getIntrinsicHeight();
            appIconBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(appIconBitmap);
            appIcon.setBounds(0, 0, width, height);
            appIcon.draw(canvas);
        }
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        appIconBitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
        return stream.toByteArray();
    }
}
