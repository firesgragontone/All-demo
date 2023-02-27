import model.Person;
import org.itstack.demo.IConverter;
import org.junit.Test;

import java.util.Objects;
import java.util.function.Consumer;
import java.util.function.Predicate;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/1/27
 */
public class ConverterTest {
    public static void main(String[] args) {
        IConverter<String,Integer> converter = new IConverter<String, Integer>() {
            @Override
            public Integer convert(String from) {
                return Integer.valueOf(from);
            }
        };
        IConverter<String,Integer> converter1 = Integer::valueOf;
    }

    @Test
    public void test11() {
        Predicate<String> predicate = (s) -> s.length() > 0;

        boolean foo0 = predicate.test("foo");           // true
        boolean foo1 = predicate.negate().test("foo");  // negate否定相当于!true

        Predicate<Boolean> nonNull = Objects::nonNull;
        Predicate<Boolean> isNull = Objects::isNull;

        Predicate<String> isEmpty = String::isEmpty;
        Predicate<String> isNotEmpty = isEmpty.negate();
    }

    @Test
    public void test2(){
        Predicate<String> predicate = (s)->s.length()>0;
        System.out.println(predicate.test("foo"));

    }

    @Test
    public void test14(){
        Consumer<Person> greeter = new Consumer<Person>() {
            @Override
            public void accept(Person person) {
                System.out.println("hello,"+person.getFirstName());
            }
        };
        greeter.accept(new Person("Luke", "Skywalker"));  //Hello, Luke
    }

}
