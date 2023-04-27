文章目录
前言
一、非空校验
二、长度校验
三、数值校验
四、正则校验
五、自定义校验注解
六、校验组
前言
javax.validation校验总是混淆，特此整理。如有错误，请不吝指正。

目录
前言
一、非空校验
二、长度校验
三、数值校验
四、正则校验
五、自定义校验注解
六、校验组
一、非空校验
序号	注解	解释	适用场景
1	@NotNull	不能为null，但可以为empty，没有Size的约束	被注解的元素不能为null。接受任何类型
2	@NotEmpty	不能为null，且Size>0	被注解的String、Collection、Map、数组是不能为null或长度为0
3	@NotBlank(message =)	只用于String,不能为null且trim()之后size>0	纯空格的String也是不符合规则的，此注解只能用于验证String类型
小结：

String字段用@NotBlank

非String字段（常见Integer、Double、Decimal等）用 @NotNull 或者 @NotEmpty ，主要看对长度是否要大于0的要求，建议使用 @NotNull

二、长度校验
序号	注解	解释	适用场景
1	@Size(max=, min=)	被注释的字符串的大小必须在指定的范围内	Integer不可用，用于字符串、Collection、Map、数组等
2	@Length(min=,max=)	被注释的字符串的大小必须在指定的范围内	Integer不可用，用于字符串
小结：

对于字符串两个注解效果相同，一个汉字算一个长度，唯一的区别就是来源不通（where R U from ?）

三、数值校验
序号	注解	解释	适用场景
1	@Min(value)、@Max(value)	被注释的元素必须是一个数字，其值必须大于等于/小于等于指定的最小值	
2	@DecimalMin(value) 、@DecimalMax(value)	接受BigDecimal的字符串表示形式
（如果您处理的数字超过Long.MIN_VALUE或Long.MAX_VALUE以下，则这是唯一可能的选择。）	BigDecimal类型
3	@Range(min=,max=,message=)	注释的元素必须在合适的范围内	BigDecimal,BigInteger,CharSequence, byte, short, int, long等原子类型和包装类型（这里无论什么类型，限定的都是字段值的区间，不是字段长度的区间）
4	@Digits (integer, fraction)	限制必须为一个小数，且整数部分的位数不能超过integer，小数部分的位数不能超过fraction	double类型
小结：

@Min(value)、@Max(value) 满足大部分需求，特别的需求考虑其他的注解

四、正则校验
序号	注解	解释	适用场景
1	@Pattern(regex=,flag=)	被注释的元素必须符合指定的正则表达式（手机号，身份证号）	按需适配
2	@Email	被注释的元素必须是电子邮箱地址	邮箱地址
3	@CreditCardNumber	被注释的字符串必须通过Luhn校验算法，银行卡，信用卡等号码一般都用Luhn计算合法性	银行卡，信用卡
4	@URL(protocol=,host=,port=,regexp=,flags=)	被注释的字符串必须是一个有效的url	url
小结：

@Pattern 理论可以校验任何规则的数据字段，但是对于已有的校验，尽量使用原生注解
常用正则表达式
身份证号码：String regex = "[1-9]\\d{13,16}[a-zA-Z0-9]{1}";
手机号码（支持国际格式，+86135xxxx…（中国内地），+00852137xxxx…（中国香港））：String regex = "(\\+\\d+)?1[34578]\\d{9}$";
固定电话号码：String regex = "(\\+\\d+)?(\\d{3,4}\\-?)?\\d{7,8}$";
整数（正整数和负整数）：String regex = "\\-?[1-9]\\d+";
中文： String regex = "^[\u4E00-\u9FA5]+$";
URL地址：String regex = "(https?://(w{3}\\.)?)?\\w+\\.\\w+(\\.[a-zA-Z]+)*(:\\d{1,5})?(/\\w*)*(\\??(.+=.*)?(&.+=.*)?)?";
中国邮政编码：String regex = "[1-9]\\d{5}";
IP地址：String regex = "[1-9](\\d{1,2})?\\.(0|([1-9](\\d{1,2})?))\\.(0|([1-9](\\d{1,2})?))\\.(0|([1-9](\\d{1,2})?))";
五、自定义校验注解

```java
import static java.lang.annotation.ElementType.CONSTRUCTOR;
import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.PARAMETER;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import javax.validation.Constraint;
import javax.validation.Payload;
import javax.validation.ReportAsSingleViolation;
import javax.validation.constraints.Null;
import javax.validation.constraints.Pattern;

import org.hibernate.validator.constraints.CompositionType;
import org.hibernate.validator.constraints.ConstraintComposition;
import org.hibernate.validator.constraints.Length;

/**

 * 验证手机号，空和正确的手机号都能验证通过

 * 正确的手机号由11位数字组成，第一位为1

 * 第二位为 3、4、5、7、8

 * */
    @ConstraintComposition(CompositionType.OR)
    @Pattern(regexp = "1[3|4|5|7|8][0-9]\\d{8}")
    @Null
    @Length(min = 0, max = 0)
    @Documented
    @Constraint(validatedBy = {})
    @Target({ METHOD, FIELD, CONSTRUCTOR, PARAMETER })
    @Retention(RUNTIME)
    @ReportAsSingleViolation
    public @interface Phone {
   String message() default "手机号校验错误";

   Class<?>[] groups() default {};

   Class<? extends Payload>[] payload() default {};
    }

    //添加手机号校验注解
    @Phone
    private String phone;
```




六、校验组
没空研究。