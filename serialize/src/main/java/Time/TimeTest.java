package Time;

import java.time.LocalDate;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/6/13
 */
public class TimeTest {
    public static void main(String[] args) {
        System.out.println(LocalDate.now());
        System.out.println(LocalDate.now().minusMonths(3));
    }
}
