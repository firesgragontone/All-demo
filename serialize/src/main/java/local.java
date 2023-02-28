import java.util.concurrent.ThreadLocalRandom;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/5/9
 */
public class local {

    protected static int chooseRandomInt(int serverCount) {
        return ThreadLocalRandom.current().nextInt(serverCount);
    }

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            System.out.println(chooseRandomInt(3));
        }
    }

}
