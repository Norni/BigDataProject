package com.nuochengze.flume.interceptor;

import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;

import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class LogETLInterceptor implements Interceptor {
    @Override
    public void initialize() {

    }

    @Override
    public Event intercept(Event event) {
        byte[] body = event.getBody();
        String log_str = new String(body, StandardCharsets.UTF_8);
        Map<String, String> headers = event.getHeaders();

        if (JsonUtils.isJsonValidate(log_str)){
            if (log_str.contains("start")) {
                headers.put("topic","topic_start");
            }else{
                headers.put("topic","topic_event");
            }
            return event;
        }else{
            return null;
        }


    }

    @Override
    public List<Event> intercept(List<Event> list) {
        Iterator<Event> iterator = list.iterator();

        while (iterator.hasNext()){
            Event next = iterator.next();
            if (intercept(next) == null){
                iterator.remove();
            }
        }
        return list;
    }

    @Override
    public void close() {

    }

    public static class Builder implements Interceptor.Builder{
        @Override
        public Interceptor build() {
            return new LogETLInterceptor();
        }

        @Override
        public void configure(Context context) {
        }
    }
}
