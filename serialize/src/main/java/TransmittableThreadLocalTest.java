import com.alibaba.ttl.TransmittableThreadLocal;
import com.alibaba.ttl.TtlRunnable;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.IntStream;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/5/9
 */
public class TransmittableThreadLocalTest {


    private static final AtomicInteger ID_SEQ = new AtomicInteger();
    private static final ExecutorService EXECUTOR = Executors.newFixedThreadPool(1, r -> new Thread(r, "thread-" + ID_SEQ.getAndIncrement()));
    private static final TransmittableThreadLocal<String> ttl = new TransmittableThreadLocal<>();
    private static Integer i = 0;



    public static void main(String[] args) throws Exception {
        // 模拟接口调用
        IntStream.range(0, 10).forEach(TransmittableThreadLocalTest::testInheritableThreadLocal);
        EXECUTOR.shutdown();
    }


    public static void testInheritableThreadLocal(int s) {
        ttl.set("小奏技术" + i++);
        Future<?> submit = EXECUTOR.submit(TtlRunnable.get(new ZouTask("任务" + s)));
        try {
            submit.get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
    }

    public static class ZouTask implements Runnable{

        String taskName;

        public ZouTask(String taskName) {
            this.taskName = taskName;
        }

        @Override
        public void run() {
            System.out.println(taskName + "线程：" + Thread.currentThread().getName() + "获取到的值: " + ttl.get());
            ttl.remove();
        }
    }
}
