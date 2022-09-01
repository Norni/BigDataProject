package com.nuochengze.udtf;

import jodd.util.StringUtil;
import org.apache.hadoop.hive.ql.exec.UDFArgumentException;
import org.apache.hadoop.hive.ql.metadata.HiveException;
import org.apache.hadoop.hive.ql.udf.generic.GenericUDTF;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspectorFactory;
import org.apache.hadoop.hive.serde2.objectinspector.StructObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;
import java.util.List;


public class ParseLogLine_UDTF extends GenericUDTF {

    @Override
    public StructObjectInspector initialize(StructObjectInspector argOIs) throws UDFArgumentException {

        ArrayList<String> fieldNames = new ArrayList<String>();
        ArrayList<ObjectInspector> fieldOIs = new ArrayList<ObjectInspector>();

        fieldNames.add("field_name");
        fieldOIs.add(PrimitiveObjectInspectorFactory.javaStringObjectInspector);
        fieldNames.add("content_json");
        fieldOIs.add(PrimitiveObjectInspectorFactory.javaStringObjectInspector);

        return ObjectInspectorFactory.getStandardStructObjectInspector(fieldNames, fieldOIs);
    }

    @Override
    public void process(Object[] args) throws HiveException {

        String input = args[0].toString();

        JSONArray jsonArray = new JSONArray(input);

        for (int i = 0; i < jsonArray.length(); i++) {

            String[] result = new String[2];

            if (jsonArray.getJSONObject(i).has(args[1].toString())) {

                result[0] = jsonArray.getJSONObject(i).getString(args[1].toString());
                result[1] = jsonArray.getString(i);
            }

            forward(result);
        }
    }


    @Override
    public void close() throws HiveException {

    }
}
