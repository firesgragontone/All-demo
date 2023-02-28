package cn.bugstack.design.tutorials20;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;

/**
 * <p>
 *  配置文件
 * </p>
 *
 * @author: chenjy
 * @time: 2022/5/6
 */
@Data
@AllArgsConstructor
public class ConfigFile {
    private String versionNo;
    private String content;
    private Date dateTime;
    private String operator;
}
