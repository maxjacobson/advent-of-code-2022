import java.util.*;

public class Rucksack {
    String line;

    public Rucksack(String line) {
        this.line = line;
    }

    public Integer priorityOfCommonItem() {
        String commonItem = this.commonItem();

        Integer num = 1;
        for (char c = 'a'; c <= 'z'; ++c) {
            if (commonItem.charAt(0) == c) {
                return num;
            }
            num++;
        }

        for (char c = 'A'; c <= 'Z'; ++c) {
            if (commonItem.charAt(0) == c) {
                return num;
            }
            num++;
        }

        throw new Error("Huh??");
    }

    private String commonItem() {
        String[] first = this.itemsInFirstCompartment();
        String[] second = this.itemsInSecondCompartment();

        for (String item: first) {
            for (String otherItem: second) {
                if (Objects.equals(item, otherItem)) {
                    return item;
                }
            }
        }

        throw new Error("No overlap found in \n" + String.join("", first) + "\nand\n" + String.join("", second));
    }

    private String[] itemsInFirstCompartment() {
        Integer length = this.line.length() / 2;

        return Arrays.copyOfRange(this.line.split(""), 0, length);
    }

    private String[] itemsInSecondCompartment() {
        Integer length = this.line.length();

        return Arrays.copyOfRange(this.line.split(""), length / 2, length);
    }

}
