import java.util.Objects;

public class RucksackGroup {
    Rucksack a;
    Rucksack b;
    Rucksack c;

    public RucksackGroup(Rucksack a, Rucksack b, Rucksack c) {
        this.a = a;
        this.b = b;
        this.c = c;
    }

    public Integer priorityOfCommonItem() {
        return new Priority(this.commonItem()).value();
    }

    private char commonItem() {
        for (char item: a.allItems()) {
            for (char otherItem: b.allItems()) {
                for (char otherOtherItem: c.allItems()) {
                    if (item == otherItem && item == otherOtherItem) {
                        return item;
                    }
                }

            }
        }

        throw new Error("No overlap found");

    }
}
