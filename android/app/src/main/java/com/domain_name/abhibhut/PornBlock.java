package com.domain_name.abhibhut;

import android.accessibilityservice.AccessibilityService;
import android.app.Activity;
import android.content.Intent;
import android.view.accessibility.AccessibilityEvent;
import android.widget.Toast;

public class PornBlock extends Activity {

    public static boolean containsPornographicContent(String text) {
        /*Over here I need to add all words / links which re-direct to Adult Sites*/
        return text.toLowerCase().contains("porn");
    }

    /*This should be tested as after moving to main screen user might navigate back to search page*/
    public void porn_block()
    {

     /*   performGlobalAction(GLOBAL_ACTION_BACK)   */
    Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);

    showToast("Access to pornographic content is blocked.");
    }

    private void showToast(String message) {
        Toast.makeText(getApplicationContext(), message, Toast.LENGTH_SHORT).show();
    }

}
