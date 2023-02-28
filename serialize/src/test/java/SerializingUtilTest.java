/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/2/9
 */

import com.alla.serilize.SerializingUtil;
import org.junit.Assert;
import org.junit.Test;

import java.util.Arrays;
import java.util.List;

/**
 * 序列化和反序列化工具测试类
 *
 * @author nathan
 * @date 2019/3/17
 */
public class SerializingUtilTest {

    @Test
    public void test() {
        String expect = "hello, world.";
        byte[] serialized = SerializingUtil.serialize(expect);
        Assert.assertEquals(SerializingUtil.deserialize(serialized, String.class), expect);
    }

    @Test
    public void testMoney() {
        List<Integer> list = Arrays.asList(12, 3, 3, 5, 5, 6, 75);
        int small = list.get(0);
        int max = 0;
        for (int i = 0; i < list.size(); i++) {
            max = Math.max((list.get(i) - small), max);
            small = Math.min(list.get(i), small);
        }
        System.out.println(max);
    }
}
