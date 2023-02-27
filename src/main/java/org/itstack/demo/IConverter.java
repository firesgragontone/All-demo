package org.itstack.demo;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/1/27
 */
@FunctionalInterface
public interface IConverter<F,T> {
    T convert(F from);
}
