package com.alla.serilize;

import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.ser.BeanPropertyWriter;
import com.fasterxml.jackson.databind.ser.BeanSerializerModifier;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/5/9
 */
public class DynamicCaseFormatFieldsBeanSerializerModifier extends BeanSerializerModifier {

//    @Override
//    public List<BeanPropertyWriter> changeProperties(SerializationConfig config, BeanDescription beanDesc,
//                                                     List<BeanPropertyWriter> beanProperties) {
//        return beanProperties.stream().map(bpw -> {
//            DynamicCaseFormatFields annotation = bpw.getAnnotation(DynamicCaseFormatFields.class);
//
//            if (annotation == null || !bpw.getType().isTypeOrSubTypeOf(Map.class)
//                    || !bpw.getType().getKeyType().isTypeOrSubTypeOf(String.class)) {
//                return bpw;
//            }
//            return new DynamicCaseFormatFieldsBeanPropertyWriter(bpw, annotation);
//        }).collect(Collectors.toList());
//    }


}
