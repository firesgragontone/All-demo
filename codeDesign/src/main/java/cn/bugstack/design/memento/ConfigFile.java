package cn.bugstack.design.memento;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;

/**
 * <p>
 *  配置类
 * </p>
 *
 * @author: chenjy
 * @time: 2023/2/16
 */
@Data
@AllArgsConstructor
public class ConfigFile {
    
    private String versionNo;//版本号
    
    private String content;//内容
    
    private Date dateTime;//时间
    
    private String operator;//操作人
}
