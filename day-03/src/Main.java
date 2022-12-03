import java.io.IOException;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.Iterator;;

public class Main {
    public static void main (String[] args) throws IOException {
        String input = new String(Files.readAllBytes(Paths.get("input.txt")));

        Integer sum = 0;

        for (String line: input.split("\n")) {
            Rucksack rucksack = new Rucksack(line);

            sum += rucksack.priorityOfCommonItem();
        }
        System.out.println("Star one: " + sum);



        // Star two

        ArrayList<Rucksack> rucksacks = new ArrayList<>();

        ArrayList<RucksackGroup> groups = new ArrayList<RucksackGroup>();

        for (String line: input.split("\n")) {
            Rucksack rucksack = new Rucksack(line);
            rucksacks.add(rucksack);
        }

        Iterator<Rucksack> rucksackIterator = rucksacks.iterator();


        while (true) {
            if (rucksackIterator.hasNext()) {
                groups.add(
                        new RucksackGroup(
                                rucksackIterator.next(),
                                rucksackIterator.next(),
                                rucksackIterator.next()
                        )
                );
            } else {
                break;
            }
        }

        Integer otherSum = 0;

        for (RucksackGroup group: groups) {
            otherSum += group.priorityOfCommonItem();
        }

        System.out.println("Star two: " + otherSum);
    }
}
