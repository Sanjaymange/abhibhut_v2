package com.domain_name.abhibhut;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.provider.Settings;

import androidx.annotation.Nullable;

import com.abhibhut.Utils.UsagePermissionMonitor;
import com.example.abhibhut_v2.R;

public class usage_access extends Activity {

    private UsagePermissionMonitor permissionMonitor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.openSettings();
        permissionMonitor = new UsagePermissionMonitor(this);
        permissionMonitor.startListening();
    }

    public void openSettings()
    {
        Intent intent = new Intent(Settings.ACTION_APP_USAGE_SETTINGS);
        startActivity(intent);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Stop listening for permission changes when activity is destroyed
        permissionMonitor.stopListening();
    }
}
