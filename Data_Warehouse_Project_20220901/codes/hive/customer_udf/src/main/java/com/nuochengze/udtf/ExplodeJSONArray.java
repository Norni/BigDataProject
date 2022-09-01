package com.nuochengze.udtf;

import org.apache.hadoop.hive.ql.exec.UDFArgumentException;
import org.apache.hadoop.hive.ql.metadata.HiveException;
import org.apache.hadoop.hive.ql.udf.generic.GenericUDTF;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspectorFactory;
import org.apache.hadoop.hive.serde2.objectinspector.StructField;
import org.apache.hadoop.hive.serde2.objectinspector.StructObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;
import org.json.JSONArray;

import java.util.ArrayList;
import java.util.List;

public class ExplodeJSONArray extends GenericUDTF {
    @Override
    public StructObjectInspector initialize(StructObjectInspector argOIs) throws UDFArgumentException {
        // 1 参数合法性检查
        if (argOIs.getAllStructFieldRefs().size() != 1) {
            throw new UDFArgumentException("ExplodeJSONArray 只需要一个参数");
        }

        // 2 第一个参数必须为string
        if (!"string".equals(argOIs.getAllStructFieldRefs().get(0).getFieldObjectInspector().getTypeName())) {
            throw new UDFArgumentException("json_array_to_struct_array的第1个参数应为string类型");
        }

        // 3 定义返回值名称和类型
        List<String> fieldNames = new ArrayList<String>();
        List<ObjectInspector> fieldOIs = new ArrayList<ObjectInspector>();

        fieldNames.add("items");
        fieldOIs.add(PrimitiveObjectInspectorFactory.javaStringObjectInspector);

        return ObjectInspectorFactory.getStandardStructObjectInspector(fieldNames, fieldOIs);

    }

    @Override
    public void process(Object[] args) throws HiveException {

        String json_array = args[0].toString();

        JSONArray jsonArray = new JSONArray(json_array);

        for (int i = 0; i < jsonArray.length(); i++) {

            String[] result = new String[1];

            result[0] = jsonArray.getString(i);

            forward(result);
        }
    }

    @Override
    public void close() throws HiveException {

    }
}
