import java.io.IOException;
import java.nio.file.*;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.IntStream;

class PairOfElves {
    Set<Integer> assignmentOne;
    Set<Integer> assignmentTwo;

    public PairOfElves(String line) {
        String[] ranges = line.split(",");
        this.assignmentOne = parseAssignment(ranges[0]);
        this.assignmentTwo = parseAssignment(ranges[1]);
    }

    private Set<Integer> parseAssignment(String assignment) {
        String[] range = assignment.split("-");

        Set<Integer> set = new HashSet<>();


        IntStream stream = IntStream.range(
                Integer.valueOf(range[0]),
                Integer.valueOf(range[1]) + 1
        );

        for (Integer num: stream.toArray()) {
            set.add(num);
        }

        return set;
    }

    public boolean totalOverlap() {
        return assignmentOne.containsAll(assignmentTwo) || assignmentTwo.containsAll(assignmentOne);
    }

    public boolean partialOverlap() {
        return assignmentOne.stream().anyMatch(a -> assignmentTwo.contains(a)) ||
                assignmentTwo.stream().anyMatch(b -> assignmentOne.contains(b));
    }


}

public class Main {
    public static void main (String[] args) throws IOException {
        String input = new String(Files.readAllBytes(Paths.get("input.txt")));

        Integer starOneCount = 0;

        for (String line: input.split("\n")) {
            PairOfElves pair = new PairOfElves(line);

            if (pair.totalOverlap()) {
                starOneCount += 1;
            }
        }

        System.out.println("Star one: " + starOneCount);

        Integer starTwoCount = 0;

        for (String line: input.split("\n")) {
            PairOfElves pair = new PairOfElves(line);

            if (pair.partialOverlap()) {
                starTwoCount += 1;
            }
        }

        System.out.println("Star two: " + starTwoCount);
    }
}
