package org.itstack.demo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/4/28
 */
public class Option {
    @Data
    static class BusinessContractDetailVO{
        BigDecimal capitalAmt;
    }

    public static void main(String[] args) {
        Optional<String> empty = Optional.empty();
        List<BusinessContractDetailVO> records = new ArrayList<>();

        //累计发行金额
//        BigDecimal capitalAmt = Optional.ofNullable(records)
//                .map(u -> u.get(0))
//                .map(BusinessContractDetailVO::getCapitalAmt)
//                .orElseGet(() -> new BigDecimal(0));

        BigDecimal capitalAmt = records.stream().findFirst().map(BusinessContractDetailVO::getCapitalAmt).orElseGet(() -> new BigDecimal(0));
        System.out.println(capitalAmt);

    }
}
