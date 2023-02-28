package cn.bugstack.design.convert;

import cn.hutool.core.convert.Convert;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.junit.Test;

import java.text.Collator;
import java.util.*;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/7/12
 */

public class ConvertTest {

    @Test
    public void test01(){
        int a = 1;
//aStr为"1"
        String aStr = Convert.toStr(a);

        long[] b = {1,2,3,4,5};
//bStr为："[1, 2, 3, 4, 5]"
        String bStr = Convert.toStr(b);
    }

    @Test
    public void test02(){
        long[] b = {1,2,3,4,5};
        JSONObject jstr = new JSONObject();
        jstr.put("test","to");
        String requestParamsString = "{\"test\":\"to\"}";
        System.out.println(requestParamsString);
        System.out.println(JSON.parseObject(requestParamsString));
    }

    @Test
    public void sortTest(){
        String[] names = {"王林",  "杨宝", "李镇", "刘迪", "刘波"};
        Arrays.sort(names, Collator.getInstance());//升序;
        System.out.println(Arrays.toString(names));

        List<String> res = Arrays.asList(names);

        List<String> list1 = new ArrayList<String>();


        list1.add("网易汽车");
        list1.add("新民汽车网");
        list1.add("钛媒体");
        list1.add("瘾科技");
        list1.add("昕薇网");
        list1.add("安倍");
        list1.add("中国");
        list1.add("中心");
        list1.sort((o1, o2) -> Collator.getInstance(Locale.CHINA).compare(o1, o2));
        System.out.println(list1);
    }

    public static void main(String[] args) {
        List<String> res = Arrays.asList("经营风险-舆情风险",
                "经营风险-司法风险",
                "钛媒体-1",
                "钛媒体-4",
                "钛媒体-3",
                "瘾科技",
                "市场风险-证券市场波动",
                "经济风险-司法风险",
                "信用风险-评级变动风险",
                "缓释措施",
                "市场风险-债券结构",
                "治理和管理风险-股权风险",
                "关联企业风险-企业实控人关联风险",
                "治理和管理风险-企业核心信息变更风险",
                "财务风险-盈利能力风险",
                "市场风险-债券结构风险");

        res.sort((o1, o2) -> Collator.getInstance(Locale.CHINA).compare(o1, o2));
        System.out.println(res);

    }

}
