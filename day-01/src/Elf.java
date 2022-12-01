import java.util.ArrayList;

public class Elf implements Comparable<Elf> {
    public ArrayList<Integer> calories;

    public Elf() {
        this.calories = new ArrayList();
    }

    public void addLine(String line) {
        Integer value = Integer.valueOf(line);
        this.calories.add(value);
    }

    public int caloriesSum() {
        return this.calories.stream().reduce(0, (a, b) -> a + b);
    }

    public int compareTo(Elf other) {
        Integer sum = this.caloriesSum();
        Integer otherSum = other.caloriesSum();
        return sum.compareTo(otherSum);
    }
}
