public class Priority {
    char c;
    public Priority(char c) {
        this.c = c;
    }

    public Integer value() {
        Integer num = 1;
        for (char c = 'a'; c <= 'z'; ++c) {
            if (this.c == c) {
                return num;
            }
            num++;
        }

        for (char c = 'A'; c <= 'Z'; ++c) {
            if (this.c == c) {
                return num;
            }
            num++;
        }

        throw new Error("Huh??");
    }
}
