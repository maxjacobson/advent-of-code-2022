import java.util.*;

public class Rucksack {
    String line;

    public Rucksack(String line) {
        this.line = line;
    }

    public Integer priorityOfCommonItem() {
        char commonItem = this.commonItem();

        return new Priority(commonItem).value();
    }

    public char[] allItems() {
        return this.line.toCharArray();
    }

    private char commonItem() {
        char[] first = this.itemsInFirstCompartment();
        char[] second = this.itemsInSecondCompartment();

        for (char item: first) {
            for (char otherItem: second) {
                if (Objects.equals(item, otherItem)) {
                    return item;
                }
            }
        }

        throw new Error("No overlap found");
    }

    private char[] itemsInFirstCompartment() {
        Integer length = this.line.length() / 2;

        return Arrays.copyOfRange(this.allItems(), 0, length);
    }

    private char[] itemsInSecondCompartment() {
        Integer length = this.line.length();

        return Arrays.copyOfRange(this.allItems(), length / 2, length);
    }

}
