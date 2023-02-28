package cn.bugstack.stream;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/7/12
 */
public class StreamTest {
    public static void main(String[] args) {
        List<Integer> lis = new ArrayList<>();
        lis.add(1);
        lis.add(2);
        lis.add(3);
        lis.add(4);
        lis.add(5);
        lis = lis.stream().filter(i -> i==3).collect(Collectors.toList());
        System.out.println(lis);
    }
}
