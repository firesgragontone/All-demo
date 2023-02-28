package cn.bugstack.design.bridge;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2023/2/14
 */
public class PayCypher implements IPayMode{

    protected Logger logger =  LoggerFactory.getLogger(PayFaceMode.class);

    @Override
    public boolean security(String uId) {
        logger.info("密码支付");
        return true;
    }
}
