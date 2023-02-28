package com.alla.serilize;

import com.fasterxml.jackson.annotation.JacksonAnnotation;
import com.google.common.base.CaseFormat;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/5/9
 */
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@JacksonAnnotation
public @interface DynamicCaseFormatFields {

    CaseFormat sourceFormat() default CaseFormat.LOWER_CAMEL;

    CaseFormat format() default CaseFormat.LOWER_CAMEL;

    boolean withNumber() default false;

}