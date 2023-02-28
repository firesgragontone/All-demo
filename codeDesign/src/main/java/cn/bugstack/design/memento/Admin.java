package cn.bugstack.design.memento;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 管理员类
 *
 * @author chenjy
 * @date 2023/2/16-15:34 星期四
 */
public class Admin {
    private int cursorIdx = -1;
    private List<ConfigMemento> mementoList = new ArrayList<>();
    private Map<String,ConfigMemento> mementoMap = new ConcurrentHashMap<>();
    public void append(ConfigMemento memento){
        mementoList.add(memento);
        mementoMap.put(memento.getFile().getVersionNo(),memento);
        cursorIdx++;
    }
    
    public ConfigMemento undo(){
        if(--cursorIdx <= 0){
            return mementoList.get(0);
        }
        return mementoList.get(cursorIdx);
    }
    
    public ConfigMemento redo(){
        if(++cursorIdx >= mementoList.size()){
            return mementoList.get(mementoList.size() - 1);
        }
        return mementoList.get(cursorIdx);
    }
    
    public ConfigMemento get(String versionNo){
        return mementoMap.get(versionNo);
    }
    
}
