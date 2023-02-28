package cn.bugstack.design.bridge;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2023/2/14
 */
public interface IPayMode {
    boolean security(String uId);
}
