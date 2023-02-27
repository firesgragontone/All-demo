package org.itstack.demo;

import lombok.SneakyThrows;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/4/28
 */
public class FileWrite {
    @SneakyThrows
    public static void main(String[] args) {
        String path = "C:\\Users\\ThinkPad\\Desktop";
        //判断文件是否存在
        File file = new File(path + "/广告计划报表数据筛选.txt");
        if (file.exists()) {
            System.out.println("文件存在");
        } else {
            try {
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
            System.out.println("文件创建成功");
        }
        //将list写入文件
        Writer out = new FileWriter(file);
        List<String> list = new ArrayList<>();
        BufferedWriter bw = new BufferedWriter(out);
        for (int j = 0; j < list.size(); j++) {
            bw.write(list.get(j));
            bw.newLine();
            bw.flush();
        }
        bw.close();
    }
}
