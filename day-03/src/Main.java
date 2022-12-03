import java.io.IOException;
import java.nio.file.*;;

public class Main {
    public static void main (String[] args) throws IOException {
        String input = new String(Files.readAllBytes(Paths.get("input.txt")));

        Integer sum = 0;

        for (String line: input.split("\n")) {
            Rucksack rucksack = new Rucksack(line);

            sum += rucksack.priorityOfCommonItem();
        }
        System.out.println("Sum: " + sum);
    }
}
