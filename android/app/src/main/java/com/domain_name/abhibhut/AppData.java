package com.domain_name.abhibhut;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.ByteArrayOutputStream;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppData {

    static final String PREF_FILE_NAME = "com.abhibhut.blocked_apps";
    public static List<Map<String, Object>> InstalledAppList(Context context) {

        PackageManager pkg_mgr = context.getPackageManager();

        List<Map<String, Object>> appList = new ArrayList<>();

        List<ApplicationInfo> appinfo = get_user_installed_apps(pkg_mgr);

        ArrayList<Map<String,String>> read_pref = read_pref(context);

        List<String> blocked_pkg = getBlockedPkgs(read_pref);

        for(ApplicationInfo appInfo : appinfo)
        {
            Map<String , Object> app_data = new HashMap<>();

            String package_nm = appInfo.packageName;
                app_data.put("app_name",pkg_mgr.getApplicationLabel(appInfo));
                app_data.put("icon", get_icon(appInfo,pkg_mgr));

                /*Checking is app is blocked*/
                if (!read_pref.get(0).containsKey("No_blocked_apps")) {
                    if (blocked_pkg.contains(package_nm)) {
                        for (Map<String, String> blockedApp : read_pref) {
                            String blocked_pkg_nm = blockedApp.get("package_name");
                            if (blocked_pkg_nm.equals(package_nm)) {
                                app_data.put("blocked_app", "Y");
                                app_data.put("start_time", blockedApp.get("start_time"));
                                app_data.put("end_time", blockedApp.get("end_time"));
                            }
                        }
                    }
                }
                else {
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
    public static byte[] get_icon(ApplicationInfo appInfo, PackageManager pkgMgr) {
        Drawable appIcon = appInfo.loadIcon(pkgMgr);
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


    public static ArrayList<Map<String,String>> read_pref(Context context)
    {
        ArrayList<Map<String,String>> read_pref = new ArrayList<>();
        SharedPreferences pref = context.getSharedPreferences(PREF_FILE_NAME,Context.MODE_PRIVATE);
        String pkg_json = pref.getString("blocked_pkg",null);
        if(pkg_json==null)
        {
            Map<String, String> noBlockedApps = new HashMap<>();
            noBlockedApps.put("No_blocked_apps"," ");
            read_pref.add(noBlockedApps);
            return read_pref;
        }
        Gson gson = new Gson();
        Type type = new TypeToken<ArrayList<Map<String,String>>>() {}.getType();
        read_pref = gson.fromJson(pkg_json,type);
        return read_pref;
    }

    /* This function is used as we need a list to iterate and compare all the installed
    * pkgs with blocked_pkgs */
   public static List<String> getBlockedPkgs(ArrayList<Map<String,String>> read_pref)
    {
        List<String> blocked_pkgs = new ArrayList<>();
        for (Map<String, String> blockedPackage : read_pref)
        {
            String package_nm = blockedPackage.get("package_name");
            blocked_pkgs.add(package_nm);
        }
        return blocked_pkgs;
    }

    /*This method will be used to update main shared preference*/

    public static void update_master_shared_preference(Context context, ArrayList<Map<String,String>> new_pref) {
        SharedPreferences preferences = context.getSharedPreferences(PREF_FILE_NAME, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        /*First we need to remove package before re-inserting new package*/
        editor.clear();
        Gson gson = new Gson();
        String json = gson.toJson(new_pref);
        editor.putString("blocked_pkg", json);
        editor.apply();
    }

    /*This method will be used to update app level shared preference */
    public static void update_app_shared_preference(Context context ,String file_nm , int start_time , int end_time , String Url)
    {
        SharedPreferences preferences = context.getSharedPreferences(file_nm, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.clear();
        editor.putInt("start_time",start_time);
        editor.putInt("end_time",start_time);
        editor.putString("Url",Url);
        editor.apply();
    }
}
