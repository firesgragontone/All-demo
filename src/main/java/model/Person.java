package model;

import lombok.Data;

@Hint("hint1")
@Hint("hint2")
@Data
public class Person {
    String firstName;
    String lastName;

    Person() {}

    public Person(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }
}
