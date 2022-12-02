import java.util.Objects;

enum Weapon {
    ROCK,
    PAPER,
    SCISSORS
}

public class Game {
    public String line;
    Integer star;

    public Game(String line, Integer star) {
        this.line = line;
        this.star = star;
    }

    public Integer score() {
        return myWeaponScore() + outcomeScore();
    }

    private Integer myWeaponScore() {
        if (this.myWeapon() == Weapon.SCISSORS) {

            return 3;
        }else if (this.myWeapon() == Weapon.ROCK) {
            return 1;
        }else {
            return 2;
        }
    }

    private Integer outcomeScore() {
        if (this.isDraw()) {
            return 3;
        } else if (this.iWon()) {
            return 6;
        } else {
            return 0;
        }
    }

    private boolean iWon() {
        return (
                (this.myWeapon() == Weapon.SCISSORS && this.theirWeapon() == Weapon.PAPER) ||
                        (this.myWeapon() == Weapon.ROCK && this.theirWeapon() == Weapon.SCISSORS) ||
                        (this.myWeapon() == Weapon.PAPER && this.theirWeapon() == Weapon.ROCK)
                );
    }

    private boolean isDraw() {
        return this.myWeapon() == this.theirWeapon();
    }

    private Weapon myWeapon() {
        String code = line.split(" ")[1];

        if (this.star == 1) {
            if (Objects.equals(code, "X")) {
                return Weapon.ROCK;
            } else if (Objects.equals(code, "Y")) {
                return Weapon.PAPER;
            } else if (Objects.equals(code, "Z")){
                return Weapon.SCISSORS;
            } else {
                throw new Error("Sorry: " + code + "??");
            }
        } else {
            if (Objects.equals(code, "X")) {
                return this.weaponThatLosesToTheirWeapon();
            } else if (Objects.equals(code, "Y")) {
                return this.theirWeapon();
            } else if (Objects.equals(code, "Z")) {
                return this.weaponThatBeatsTheirWeapon();
            } else {
                throw new Error("Sorry: " + code);
            }
        }

    }

    private Weapon weaponThatBeatsTheirWeapon() {
        if (this.theirWeapon() == Weapon.SCISSORS) {
            return Weapon.ROCK;
        } else if (this.theirWeapon() == Weapon.ROCK) {
            return Weapon.PAPER;
        } else if (this.theirWeapon() == Weapon.PAPER) {
            return Weapon.SCISSORS;
        } else {
            throw new Error("HUH???");
        }
    }

    private Weapon weaponThatLosesToTheirWeapon() {
        if (this.theirWeapon() == Weapon.SCISSORS) {
            return Weapon.PAPER;
        } else if (this.theirWeapon() == Weapon.ROCK) {
            return Weapon.SCISSORS;
        } else if (this.theirWeapon() == Weapon.PAPER) {
            return Weapon.ROCK;
        } else {
            throw new Error("HUH???");
        }
    }

    private Weapon theirWeapon() {
        String code = line.split(" ")[0];


        if (Objects.equals(code, "A")) {
            return Weapon.ROCK;
        } else if (Objects.equals(code, "B")) {
            return Weapon.PAPER;
        } else if (Objects.equals(code, "C")){
            return Weapon.SCISSORS;
        }else {
            throw new Error("Sorry: " + code);
        }
    }
}
