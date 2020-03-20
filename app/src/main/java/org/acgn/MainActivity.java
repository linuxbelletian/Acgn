package org.acgn;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.TextView;

import org.acgn.player.HelloJni;

import java.util.Locale;

public class MainActivity extends AppCompatActivity {

    private HelloJni jni = new HelloJni();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Example of a call to a native method
        TextView tv = findViewById(R.id.sample_text);
        tv.setText(
                String.format(Locale.getDefault(),"%spng version: %d", jni.stringFromJNI(), jni.pngVersion()));
    }
}
