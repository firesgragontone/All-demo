package cn.bugstack.design.tutorials20;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * <p>
 *  备忘录
 * </p>
 *
 * @author: chenjy
 * @time: 2022/5/6
 */
@Data
@AllArgsConstructor
public class ConfigMemento {
    private ConfigFile configFile;
}
