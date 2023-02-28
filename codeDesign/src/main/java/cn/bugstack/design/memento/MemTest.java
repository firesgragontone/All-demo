package cn.bugstack.design.memento;

import com.alibaba.fastjson.JSON;
import lombok.extern.slf4j.Slf4j;

import java.util.Date;

/**
 * 备忘录测试
 *
 * @author chenjy
 * @date 2023/2/16-16:00 星期四
 */
@Slf4j
public class MemTest {
  public static void main(String[] args) {
    //
    Admin admin = new Admin();
    ConfigOriginator configOriginator = new ConfigOriginator();
    configOriginator.setConfigFile(new ConfigFile("101","配置内容弄A=哈哈", new Date(),"小福哥"));
    admin.append(configOriginator.saveMemento());
    configOriginator.setConfigFile(new ConfigFile("102","配置内容弄A=嘻嘻", new Date(),"小福哥"));
    admin.append(configOriginator.saveMemento());
    configOriginator.setConfigFile(new ConfigFile("103","配置内容弄A=么么", new Date(),"小福哥"));
    admin.append(configOriginator.saveMemento());
    configOriginator.setConfigFile(new ConfigFile("104","配置内容弄A=嘿嘿", new Date(),"小福哥"));
    admin.append(configOriginator.saveMemento());
    
    configOriginator.getMemento(admin.undo());
    log.info("历史配置（回滚）undo:{}", JSON.toJSONString(configOriginator.getConfigFile()));
    
    configOriginator.getMemento(admin.undo());
    log.info("历史配置（回滚）undo:{}", JSON.toJSONString(configOriginator.getConfigFile()));
    
    configOriginator.getMemento(admin.redo());
    log.info("历史配置（前进）redo:{}", JSON.toJSONString(configOriginator.getConfigFile()));
    
    configOriginator.getMemento(admin.redo());
    log.info("历史配置（前进）redo:{}", JSON.toJSONString(configOriginator.getConfigFile()));
    
    configOriginator.getMemento(admin.get("102"));
    log.info("历史配置（获取）get:{}", JSON.toJSONString(configOriginator.getConfigFile()));
    
  }
}
