package com.lion.owl_im_sdk.listener;

import com.lion.owl_im_sdk.util.CommonUtil;

public class OnUserListener implements open_im_sdk_callback.OnUserListener {

    @Override
    public void onSelfInfoUpdated(String s) {
        CommonUtil.emitEvent("userListener", "onSelfInfoUpdated", s);
    }

    @Override
    public void onUserStatusChanged(String s) {
        CommonUtil.emitEvent("userListener", "onUserStatusChanged", s);
    }
}
