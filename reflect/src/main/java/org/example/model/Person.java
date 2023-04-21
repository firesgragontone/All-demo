package org.example.model;

/**
 * @author chenjy
 * @date 2023/4/20-16:00 星期四
 */
public class Person {
    private String name;
    private int age;
    private String gender;

    public Person(String n, int a, String g) {
        name = n;
        age = a;
        gender = g;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    public String getGender() {
        return gender;
    }
}
