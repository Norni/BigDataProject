package com.nuochengze.flume.interceptor;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONException;

public class JsonUtils {
    public static boolean isJsonValidate(String log){
        try{
            JSON.parse(log);
            return true;
        }catch (JSONException e){
            return false;
        }
    }
}
