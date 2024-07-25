package com.lion.owl_im_sdk.listener;

import com.lion.owl_im_sdk.util.CommonUtil;

public class OnCustomBusinessListener implements open_im_sdk_callback.OnCustomBusinessListener {
    @Override
    public void onRecvCustomBusinessMessage(String s) {
        CommonUtil.emitEvent("customBusinessListener", "onRecvCustomBusinessMessage", s);
    }
}
