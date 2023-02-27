package org.itstack.demo.pool;

/**
 * <p>
 *   通过开启守护线程执行任务，主线程销毁守护线程也会跟着一同销毁
 * </p>
 *
 * @author: chenjy
 * @time: 2022/4/21
 */
public class WorkerService {
    private Thread executeService;
    private volatile boolean finished = false;
    public void execute(Runnable task){
        executeService = new Thread(()->{
            Thread runner = new Thread(task);
            runner.setDaemon(true);
            runner.start();
            try{
                runner.join();
                finished = true;
            }catch (InterruptedException e){
                System.out.println("打断正在工作的线程");
            }
        });
        executeService.start();
    }
    public void listener(long mills){
        System.out.println("开启监听");
        long currentTime = System.currentTimeMillis();
        while(!finished){
            if((System.currentTimeMillis() - currentTime)>=mills){
                System.out.println("工作耗时过长，开始打断");
                executeService.interrupt();
                break;
            }
            try {
                executeService.sleep(100L);
            }catch (InterruptedException e){
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        WorkerService service = new WorkerService();
        long start = System.currentTimeMillis();
        service.execute(()->{
            try {
                Thread.sleep(3*1000);
            }catch (InterruptedException e){
                e.printStackTrace();
            }
        });
        service.listener(4*1000);
        System.out.println(System.currentTimeMillis() - start);
    }





}
