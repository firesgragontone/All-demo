package cn.bugstack.design.bridge;

import java.math.BigDecimal;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2023/2/15
 */
public class WxPay extends Pay{
    protected WxPay(IPayMode payMode) {
        super(payMode);
    }

    @Override
    public String transfer(String uId, String tradeId, BigDecimal amount) {
        logger.info("模拟转账开始，uid：{}，tradeid:{},amount：{}",uId,tradeId,amount);
        boolean security = payMode.security(uId);
        if(!security){
            logger.info("模拟支付宝渠道划转拦截。");
            return "0001";
        }
        logger.info("模拟微信拦截成功");
        return "0000";
    }
}
