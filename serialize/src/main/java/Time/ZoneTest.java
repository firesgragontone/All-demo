package Time;

import java.time.*;
import java.util.Date;

/**
 * <p>
 *
 * </p>
 *
 * @author: chenjy
 * @time: 2022/7/4
 */
public class ZoneTest {
    public static void main(String[] args) {
        System.out.println(System.currentTimeMillis());
        System.out.println(LocalDateTime.now());
        System.out.println(Instant.now().getEpochSecond());
        System.out.println(Instant.now());
        System.out.println(new Date().toInstant());

        System.out.println("-------------------------------------");

        System.out.println(LocalDateTime.now().toInstant(ZoneOffset.of("+8")).toEpochMilli());System.out.println(LocalDateTime.now().atZone(ZoneId.systemDefault()).toEpochSecond());
        System.out.println(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant().getEpochSecond());
        System.out.println(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli());
        System.out.println(LocalDateTime.now().atOffset(OffsetDateTime.now().getOffset()).toEpochSecond());
        System.out.println(LocalDateTime.now().atOffset(OffsetDateTime.now().getOffset()).toInstant().getEpochSecond());
        System.out.println(LocalDateTime.now().atOffset(OffsetDateTime.now().getOffset()).toInstant().toEpochMilli());

        System.out.println("========================================");

        Instant instant = Instant.now();
        System.out.println(new Date(instant.getEpochSecond()*1000));
        System.out.println(LocalDateTime.ofInstant(instant, ZoneId.systemDefault()));
    }


//结果
//1576405826436
//2019-12-15T18:30:26.551
//1576405826
//2019-12-15T10:30:26.552Z
//2019-12-15T10:30:26.562Z
//-------------------------------------
//1576406278199
//1576405826
//1576405826
//1576405826563
//1576405826
//1576405826
//1576405826564
//========================================
//Sun Dec 15 18:46:54 CST 2019
//2019-12-15T18:46:54.303


}
