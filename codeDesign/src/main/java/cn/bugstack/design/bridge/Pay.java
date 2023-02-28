package cn.bugstack.design.bridge;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;

/**
 * @author: chenjy
 * @time: 2023/2/14
 */
public abstract class Pay {

  protected Logger logger = LoggerFactory.getLogger(Pay.class);

  protected IPayMode payMode;

  protected Pay(IPayMode payMode) {
    this.payMode = payMode;
  }

  public abstract String transfer(String uId, String tradeId, BigDecimal amount);
}
