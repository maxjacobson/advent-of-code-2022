import java.util.Arrays;

public class Strategy {
    public Game[] games;
    public Strategy(String input, Integer star) {
        this.games = Arrays.stream(input.split("\n")).map(line -> new Game(line, star)).toArray(Game[]::new);
    }
}
