package cn.bugstack.design.tutorials20;

import jdk.nashorn.internal.objects.annotations.Constructor;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * <p>
 *  记录者
 * </p>
 *
 * @author: chenjy
 * @time: 2022/5/6
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ConfigOriginator {
    private  ConfigFile configFile;
    public ConfigMemento saveMemento(){
        return new ConfigMemento(this.configFile);
    }
    public void getMemento(ConfigMemento configMemento){
        this.configFile = configMemento.getConfigFile();
    }

}
