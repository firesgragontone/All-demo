package cn.bugstack.design.bridge;

import java.math.BigDecimal;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2023/2/14
 */
public class ZfbPay extends Pay{

    protected ZfbPay(IPayMode payMode){
        super(payMode);
    }

    @Override
    public String transfer(String uId, String tradeId, BigDecimal amount) {
        logger.info("模拟支付宝转账");
        boolean security = payMode.security(uId);
        if(!security){
            logger.info("模拟支付宝支付拦截");
            return "0001";
        }
        logger.info("支付宝支付成功");
        return "0000";
    }
}
