package com.compdfkit.flutter.compdfkit_flutter;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;

/**
 * This demonstrates a simple unit test of the Java portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

public class CompdfkitFlutterPluginTest {
  @Test
  public void constructor_createsPluginInstance() {
    CompdfkitFlutterPlugin plugin = new CompdfkitFlutterPlugin();

    assertNotNull(plugin);
  }
}
