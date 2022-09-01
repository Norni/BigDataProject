package com.nuochengze.udf;

import org.apache.hadoop.hive.ql.exec.UDFArgumentException;
import org.apache.hadoop.hive.ql.metadata.HiveException;
import org.apache.hadoop.hive.ql.udf.generic.GenericUDF;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;
import org.json.JSONObject;


import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ParseLogLine_UDF extends GenericUDF {

    private String result;

    @Override
    public ObjectInspector initialize(ObjectInspector[] arguments) throws UDFArgumentException {

        this.result = null;
        // 确定返回值类型
        return PrimitiveObjectInspectorFactory.javaStringObjectInspector;
    }

    @Override
    public Object evaluate(DeferredObject[] arguments) throws HiveException {

        String line = arguments[0].get().toString();

        if (line.contains("common")) {

            Matcher matcher = Pattern.compile("\\{.*").matcher(line);

            if (matcher.find()) {
                String new_line = matcher.group();
                JSONObject base_json_line = new JSONObject(new_line.trim());

                // 判断参数个数
                if (arguments.length == 3) {

                    if (base_json_line.has(arguments[1].get().toString())) {

                        JSONObject second_json_line = (JSONObject) base_json_line.get(arguments[1].get().toString());

                        if (second_json_line.has(arguments[2].get().toString())) {

                            this.result = second_json_line.getString(arguments[2].get().toString());

                            return this.result;
                        }
                    }
                } else if (arguments.length == 2) {

                    if (base_json_line.has(arguments[1].get().toString())) {

                        this.result = base_json_line.getString(arguments[1].get().toString());

                        return this.result;
                    }
                } else if (arguments.length == 1){
                    return new_line;
                }
            }
        }
        return null;
    }

    @Override
    public String getDisplayString(String[] children) {
        return null;
    }
}
