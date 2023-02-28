package cn.bugstack.design.memento;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * 备忘录类
 *
 * @author chenjy
 * @date 2023/2/16-15:36 星期四
 */
@Data
@AllArgsConstructor
public class ConfigMemento {
    private ConfigFile file;
}
