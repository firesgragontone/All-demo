package func;

import java.util.HashMap;
import java.util.Map;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/5/7
 */
@FunctionalInterface
public interface Predicate<T> {
    boolean test(T t);

    public static void main(String[] args) {
        Map<Integer, Integer> map = new HashMap<>();
        map.put(2,2);
        map.put(3,3);
        map.put(-2,-2);
        map.put(1,1);
        System.out.println(map.toString());
    }
}
