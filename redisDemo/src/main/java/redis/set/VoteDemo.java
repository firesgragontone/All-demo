package redis.set;

import redis.clients.jedis.Jedis;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * 投票统计案例
 */
public class VoteDemo {

    private Jedis jedis = new Jedis("127.0.0.1");

    /**
     * 投票
     * @param userId
     * @param voteItemId
     */
    public void vote(long userId, long voteItemId) {
        jedis.sadd("vote_item_users::" + voteItemId, String.valueOf(userId));
    }

    /**
     * 检查用户对投票项是否投过票
     * @param userId
     * @param voteItemId
     * @return
     */
    public boolean hasVoted(long userId, long voteItemId) {
        return jedis.sismember("vote_item_users::" + voteItemId, String.valueOf(userId));
    }

    /**
     * 获取一个投票项被哪些人投票了
     * @param voteItemId
     * @return
     */
    public Set<String> getVoteItemUsers(long voteItemId) {
        return jedis.smembers("vote_item_users::" + voteItemId);
    }

    /**
     * 获取一个投票项被多少人投票了
     * @param voteItemId
     * @return
     */
    public long getVoteItemUsersCount(long voteItemId) {
        return jedis.scard("vote_item_users::" + voteItemId);
    }

    public static void main(String[] args) throws Exception {
        VoteDemo demo = new VoteDemo();

        // 定义用户id
        long userId = 1;
        // 定义投票项id
        long voteItemId = 110;

        // 进行投票
        demo.vote(userId, voteItemId);
        // 检查我是否投票过
        boolean hasVoted = demo.hasVoted(userId, voteItemId);
        System.out.println("用户查看自己是否投票过：" +(hasVoted ? "是" : "否"));
        // 归票统计
        Set<String> voteItemUsers = demo.getVoteItemUsers(voteItemId);
        long voteItemUsersCount = demo.getVoteItemUsersCount(voteItemId);
        System.out.println("投票项有哪些人投票：" + voteItemUsers + "，有几个人投票：" + voteItemUsersCount);
    }

}

class Result {

    /*
     * Complete the 'compareTriplets' function below.
     *
     * The function is expected to return an INTEGER_ARRAY.
     * The function accepts following parameters:
     *  1. INTEGER_ARRAY a
     *  2. INTEGER_ARRAY b
     */

    public static List<Integer> compareTriplets(List<Integer> a, List<Integer> b) {
        // Write your code here
        int len = a.size();
        List<Integer> ret = new ArrayList();
        for(int i=0;i<len;i++){
            if(a.get(i)>b.get(i)){
                ret.set(0,ret.get(0)+1);
            }else if(a.get(i)<b.get(i)){
                ret.set(1,ret.get(1)+1);
            }
        }
        return ret;

    }

}
 class Solution {
    public static void main(String[] args) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(System.getenv("OUTPUT_PATH")));

        List<Integer> a = Stream.of(bufferedReader.readLine().replaceAll("\\s+$", "").split(" "))
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        List<Integer> b = Stream.of(bufferedReader.readLine().replaceAll("\\s+$", "").split(" "))
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        List<Integer> result = Result.compareTriplets(a, b);

        bufferedWriter.write(
                result.stream()
                        .map(Object::toString)
                       .collect(Collectors.joining())
                        + "\n"
        );

        bufferedReader.close();
        bufferedWriter.close();
    }
}
