package org.example.util;

/**
 * @author chenjy
 * @date 2023/4/21-15:03 星期五
 */

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class TestAnnotation {

    @MyAnnotation("test")
    public void test(){
        final Class<? extends TestAnnotation> aClass = this.getClass();
        try {
            System.out.println("运行:"+aClass.getMethod("test").getAnnotation(MyAnnotation.class).value());
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }

    @MyAnnotation("test02")
    public void test02(){
        final Class<? extends TestAnnotation> aClass = this.getClass();
        try {
            System.out.println("运行:"+aClass.getMethod("test02").getAnnotation(MyAnnotation.class).value());
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws Exception {
        TestAnnotation testAnnotation = new TestAnnotation();
        testAnnotation.setAnnotationValue("editor");
        testAnnotation.test();
        testAnnotation.test02();
        new TestAnnotation().test();
        new TestAnnotation().test02();
        new Runnable() {
            @Override
            public void run() {
                new TestAnnotation().test();
                new TestAnnotation().test02();
            }
        };
    }
    //修改test02方法上方MyAnnotation注解的value值
    private void setAnnotationValue(String value) throws Exception {
        Method method = this.getClass().getMethod("test");
        MyAnnotation annotation = method.getAnnotation(MyAnnotation.class);
        Field field = String.class.getDeclaredField("value");
        field.setAccessible(true);
        field.set(annotation.value(), value.toCharArray());
        System.out.println("修改:"+annotation.value());
    }
}

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@interface MyAnnotation{
    String value();
}

