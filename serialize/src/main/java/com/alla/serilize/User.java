package com.alla.serilize;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/5/9
 */
@Data
public class User {

    private String nameInfo;

    private String ageInfo;

    private Account account;

//    @JsonSerialize(using = MapNamingStrategySerialize.class)
    private Map<String, Object> extraMap;

//    @JsonSerialize(using = MapNamingStrategySerialize.class)
    private Map<String, String> cache;

    @Data
    public static class Account {

        private Long accountId;

        @JsonProperty("name_4_user")
        private String name4User;
    }

    public static User builder() {
        User user = new User();
        user.setNameInfo("coder");
        user.setAgeInfo("28");

        Account account = new Account();
        account.setAccountId(1001L);
        account.setName4User("liming");
        user.setAccount(account);

        Map<String, Object> extra = new HashMap<>();
        extra.put("id4User", "123");
        extra.put("userAge", 23);
        extra.put("myPrice", 12.345);
        extra.put("uId", 1200L);
        extra.put("account", account);
        user.setExtraMap(extra);


        Map<String, String> cache = new HashMap<>();
        cache.put("id4Cache", "123");
        cache.put("name4Cache", "456");
        user.setCache(cache);
        return user;
    }
}