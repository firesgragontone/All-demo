package cn.bugstack.design.convert;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/7/19
 */
import cn.hutool.extra.pinyin.PinyinUtil;
import com.alibaba.fastjson.JSON;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;


public class TextUtils {


    /**
     * 数字排在最前，英文字母其次，汉字则按照拼音进行排序
     */
    public static List<String> compareTo(List<String> stringList) {
        if (CollectionUtils.isEmpty(stringList)) {
            return Collections.emptyList();
        }
        Comparator<String> comparator = (text, texts) -> {
            Collator collator = Collator.getInstance(java.util.Locale.CHINESE);
            return collator.getCollationKey(text).compareTo(
                    collator.getCollationKey(texts));
        };
        Collections.sort(stringList, comparator);
        return stringList;
    }

    /**
     * 获取中文首字母
     * @param str
     * @return
     */
    public static String getInitials(String str){
        if(StringUtils.isEmpty(str)){
            return "#";
        }
        String letter = PinyinUtil.getFirstLetter(str.substring(0, 1),"");
        return letter.toUpperCase();
    }



    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("360");
        list.add("Access");
        list.add("百度");
        list.add("民生");
        list.add("网易汽车");
        list.add("新民汽车网");
        list.add("钛媒体");
        list.add("瘾科技");
        list.add("昕薇网");
        list.add("安倍");
        list.add("中国");
        list.add("中心");
        System.out.println(JSON.toJSONString(compareTo(list)));
        System.out.println(PinyinUtil.getPinyin("中"));
    }




}

