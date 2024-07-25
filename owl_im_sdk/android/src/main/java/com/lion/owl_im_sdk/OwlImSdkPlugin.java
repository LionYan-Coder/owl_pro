package com.lion.owl_im_sdk;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import com.lion.owl_im_sdk.connectivity.ConnectivityListener;
import com.lion.owl_im_sdk.connectivity.VisibilityListener;
import com.lion.owl_im_sdk.manager.ConversationManager;
import com.lion.owl_im_sdk.manager.FriendshipManager;
import com.lion.owl_im_sdk.manager.GroupManager;
import com.lion.owl_im_sdk.manager.IMManager;
import com.lion.owl_im_sdk.manager.MessageManager;
import com.lion.owl_im_sdk.manager.UserManager;


/**
 * OwlImSdkPlugin
 */
public class OwlImSdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private static final String CHANNEL_NAME = "owl_im_sdk";
    public static MethodChannel channel;
    private static IMManager imManager;
    private static UserManager userManager;
    private static FriendshipManager friendshipManager;
    private static MessageManager messageManager;
    private static ConversationManager conversationManager;
    private static GroupManager groupManager;
    private static Activity activity;
    private static Context context;
    private ConnectivityListener connectivityListener;
    private VisibilityListener visibilityListener;
    public static boolean isInitialized;

    public OwlImSdkPlugin() {
        OwlImSdkPlugin.imManager = new IMManager();
        OwlImSdkPlugin.userManager = new UserManager();
        OwlImSdkPlugin.friendshipManager = new FriendshipManager();
        OwlImSdkPlugin.messageManager = new MessageManager();
        OwlImSdkPlugin.conversationManager = new ConversationManager();
        OwlImSdkPlugin.groupManager = new GroupManager();
    }


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_NAME);
        context = flutterPluginBinding.getApplicationContext();
        channel.setMethodCallHandler(this);
        connectivityListener = new ConnectivityListener(context);
        visibilityListener = new VisibilityListener();
        connectivityListener.register();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        parse(call, result);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        OwlImSdkPlugin.channel.setMethodCallHandler(null);
        connectivityListener.unregisterReceiver();
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        visibilityListener.register(activity = binding.getActivity());
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        visibilityListener.unregisterReceiver(activity);
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        visibilityListener.register(activity = binding.getActivity());
    }

    @Override
    public void onDetachedFromActivity() {
        visibilityListener.unregisterReceiver(activity);
        activity = null;
    }

    void parse(@NonNull MethodCall call, @NonNull Result result) {
        try {
            String managerName = call.argument("ManagerName");
            Field field = OwlImSdkPlugin.class.getDeclaredField(managerName);
            Method method = field.get(new Object()).getClass().getDeclaredMethod(call.method, MethodCall.class, Result.class);
            Log.i("F-OpenIMSDK(flutter call native)", "{ class:" + managerName + ",  method:" + method.getName() + " }");
            method.invoke(field.get(new Object()), call, result);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
