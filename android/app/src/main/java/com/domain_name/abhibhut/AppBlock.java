package com.domain_name.abhibhut;

import android.app.Activity;
import android.content.Intent;
import android.widget.Toast;

public class AppBlock extends Activity {

    public void blockAppUsage() {
        // Disable the launch of the blocked app
        disableAppLaunch();
        // show a message to the user , change toast.length_long parameter to change time
        Toast.makeText(this, "Distracting app usage blocked", Toast.LENGTH_LONG).show();

        /*Each app will have a shared preference created as com.abhibhut.label_name
        * this shared preference will have url and media type response metadata in it */

        /**/

        /*if(packageNamesMap.get("Block_MSG") != null)
        {
            Toast.makeText(this, packageNamesMap.get("Block_MSG"), Toast.LENGTH_LONG).show();
        }
        else if(packageNamesMap.get("IMG_MSG_URI") != null)
        {
            ImageViewer img= new ImageViewer(packageNamesMap.get("IMG_MSG_URI"));
        }
        else if(packageNamesMap.get("Audio_MSG_URI") != null)
        {
            /*Audio player class is generated , but its layout is not ready yet
        } */
    }
    public void disableAppLaunch() {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }
}
