package cn.bugstack.design.tutorials20.test;

import lombok.Data;

import java.util.Date;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/5/6
 */
@Data
public class ConfigFile {
    private String versionNo;
    private String content;
    private Date date;
    private String operator;

}
