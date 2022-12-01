import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Scanner;

public class CalorieCounter {
    public static void main(String[] args) {
        ArrayList<Elf> elves = new ArrayList();

        try {
            File myObj = new File("input.txt");
            Scanner myReader = new Scanner(myObj);
            Elf elf = new Elf();

            while (myReader.hasNextLine()) {
                String data = myReader.nextLine();
                if (data == "") {
                    elves.add(elf);
                    elf = new Elf();
                } else {
                    elf.addLine(data);
                }
            }
            elves.add(elf);
            myReader.close();

            elves.sort(Comparator.reverseOrder());

            System.out.println(elves.get(0).caloriesSum() + elves.get(1).caloriesSum() + elves.get(2).caloriesSum());
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }
}