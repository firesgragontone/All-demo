package cn.bugstack.design.memento;
import lombok.Data;

/**
 * 记录者类
 *
 * @author chenjy
 * @date 2023/2/16-15:30 星期四
 */
@Data
public class ConfigOriginator {
    private ConfigFile configFile;
    
    public ConfigMemento saveMemento(){
        return new ConfigMemento(configFile);
    }
    
    public void setMemento(ConfigMemento memento){
        this.configFile = memento.getFile();
    }
    
    public void getMemento(ConfigMemento memento){
        this.configFile = memento.getFile();
    }
}
