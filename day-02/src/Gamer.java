import java.io.IOException;
import java.nio.file.*;;

public class Gamer {
    public static void main (String[] args) throws IOException {
        String input = new String(Files.readAllBytes(Paths.get("input.txt")));
        Integer score = 0;
        Strategy strategy = new Strategy(input, 1);

        for (Game game: strategy.games) {
            score += game.score();
        }

        System.out.println(score);

        Strategy strategyTwo = new Strategy(input, 2);


        Integer starTwoScore = 0;

        for (Game game: strategyTwo.games) {
            starTwoScore += game.score();
        }

        System.out.println(starTwoScore);

    }
}
