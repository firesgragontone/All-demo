package org.itstack.demo.timer;

import lombok.Builder;
import lombok.Data;
import lombok.SneakyThrows;

import java.util.*;
import java.util.concurrent.*;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/4/28
 */
public class TimeWheelTest3 {

    static interface Todo {
        public void doSomeThing();
    }


    @Builder
    @Data
    static class JobInfo implements Todo {
        private Integer id;
        private Integer version;
        private Integer cron;
        private Integer isCron;
        private Integer round;
        private Integer second;
        public Todo todo;

        @Override
        public void doSomeThing() {
            System.out.println(Thread.currentThread().getName() + ":" + id + ":do what you want to do");
            if (todo != null) {
                todo.doSomeThing();
            }
        }

        public void reSetRound() {
            this.round = 0;
        }

        public void reduceRound() {
            this.round = this.round > 1 ? this.round - 1 : 0;
        }
    }

    private ThreadPoolExecutor jobTriggerPool = new ThreadPoolExecutor(20, 50, 200, TimeUnit.MILLISECONDS,
            new ArrayBlockingQueue<Runnable>(50));

    private final Map<Integer, CopyOnWriteArrayList<Integer>> ringData = new ConcurrentHashMap<>();

    private Thread timeWheelThread;

    private static volatile boolean stopTimeWheel = false;

    //启动定时器
    private void start() {
        timeWheelThread = new Thread(new Runnable() {
            @Override
            public void run() {
                while (!stopTimeWheel) {
                    try {
                        //先以秒为刻度
                        TimeUnit.SECONDS.sleep(1);
                        //当前秒
                        int nowSecond = Calendar.getInstance().get(Calendar.SECOND);
                        System.out.println("nowSecond:" + nowSecond);
                        //触发任务
                        triggerJob(nowSecond);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        });
        timeWheelThread.start();
    }

    //触发任务
    private void triggerJob(int nowSecond) {
        CopyOnWriteArrayList<Integer> itemList = ringData.get(nowSecond);
        if (itemList != null && itemList.size() > 0) {
            Iterator iterator = itemList.iterator();
            while (iterator.hasNext()) {
                Integer id = (Integer) iterator.next();
                jobTriggerPool.execute(new Runnable() {
                    @Override
                    public void run() {
                        JobInfo jobInfonow = getJobInfo(id);

                        //判断圈数
                        int round = jobInfonow.getRound();
                        if (round == 0) {
                            //执行任务
                            jobInfonow.doSomeThing();
                            jobInfonow.reSetRound();
                            jobInfonow.setIsCron(0);
                        } else {
                            jobInfonow.reduceRound();
                        }
                        if (jobInfonow.getIsCron() != 1) {
                            //环中删除任务
                            removeJob(jobInfonow);
                        }
                    }
                });
            }
        }
    }

    //停止定时器
    private void stop() {
        stopTimeWheel = true;
        timeWheelThread.interrupt();
    }

    private void addJob(JobInfo jobInfo) {
        add(jobInfo.getSecond(), jobInfo.getId());
    }

    //添加任务
    private void add(Integer second, Integer jobId) {
        CopyOnWriteArrayList<Integer> itemList = ringData.get(second);
        if (itemList == null) {
            itemList = new CopyOnWriteArrayList<>();
            itemList.add(jobId);
            ringData.put(second, itemList);
        } else {
            itemList.add(jobId);
        }
    }

    private void removeJob(JobInfo jobInfo) {
        remove(jobInfo.getSecond(), jobInfo.getId());
        System.out.println("删除任务{}" + jobInfo.getId());
    }

    //删除任务
    private void remove(Integer second, Integer jobId) {
        List<Integer> itemList = ringData.get(second);
        if (itemList == null) {
            ringData.remove(second);
        } else {
            itemList.remove(jobId);
        }
    }

    private JobInfo getJobInfo(Integer jobId) {
        return JobInfoMap.get(jobId);
    }


    static JobInfo jobInfo = null;
    static JobInfo jobInfo2 = null;
    static JobInfo jobInfo3 = null;
    static Map<Integer, JobInfo> JobInfoMap = new HashMap();

    static {

        jobInfo = JobInfo.builder().id(1).isCron(1).second(2).round(1).build();
        jobInfo.setCron(15);

        jobInfo2 = JobInfo.builder().id(2).isCron(0).second(3).round(2).build();
        jobInfo2.setCron(15);

        jobInfo3 = JobInfo.builder().id(3).isCron(1).second(3).round(3).build();
        jobInfo3.setCron(60);

        JobInfoMap.put(jobInfo.getId(), jobInfo);
        JobInfoMap.put(jobInfo2.getId(), jobInfo2);
        JobInfoMap.put(jobInfo3.getId(), jobInfo3);
    }


    public static void main(String[] args) {
        TimeWheelTest3 t = new TimeWheelTest3();
        t.start();
        for (int i = 0; i < 1000; i++) {
            int rand = Math.abs(new Random(i).nextInt());
            int rand2 = rand % 60;
            int rand3 = rand % 10;
            jobInfo = JobInfo.builder().id(i).isCron(1).second(rand2).round(rand3).isCron(1).build();
            JobInfoMap.put(jobInfo.getId(), jobInfo);
            t.addJob(jobInfo);
        }
//        t.addJob(jobInfo);
//        t.addJob(jobInfo2);
//        t.addJob(jobInfo3);


    }

}


