import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class solution {
    public static void main(String[] args) {
        String filename = "input";

        List<Puzzle> puzzles = new ArrayList<>();
        Puzzle currentPuzzle = null;

        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            String line;
            int puzzleNumber = 1;
            List<String> cols = null;
            currentPuzzle = new Puzzle(puzzleNumber);
            while ((line = reader.readLine()) != null) {
                if (line.isEmpty()) { // Start of new puzzle
                    for (int i = 0; i < cols.size(); i++)
                        currentPuzzle.addCol(cols.get(i));
                    puzzles.add(currentPuzzle);
                    puzzleNumber += 1;
                    currentPuzzle = new Puzzle(puzzleNumber);

                    cols = null;
                } else { // New puzzle board starts
                    char[] chars = line.toCharArray();
                    currentPuzzle.addRow(line);
                    if (cols == null) { // First row initialize columns
                        cols = new ArrayList<>();
                        for (int i = 0; i < chars.length; i++)
                            cols.add(String.valueOf(chars[i]));
                    } else {
                        for (int i = 0; i < chars.length; i++)
                            cols.set(i, cols.get(i) + chars[i]);
                    }
                }
            }
            if (currentPuzzle != null) { // Add last puzzle
                for (int i = 0; i < cols.size(); i++)
                    currentPuzzle.addCol(cols.get(i));
                puzzles.add(currentPuzzle);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        int score = 0;
        int score2 = 0;
        for (Puzzle puzzle : puzzles) {
            puzzle.getReflections();
            score = score + puzzle.getScore();
            score2 = score2 + puzzle.getScore2();
        }
        System.out.println("Part 1: " + score);
        System.out.println("Part 2: " + score2);
    }
}

class Puzzle {
    private int puzzleNumber;
    private List<String> rows;
    private List<String> cols;
    private int colReflection;
    private int rowReflection;
    private int colSmudgedReflection;
    private int rowSmudgedReflection;

    public Puzzle(int puzzleNumber) {
        this.puzzleNumber = puzzleNumber;
        this.rows = new ArrayList<>();
        this.cols = new ArrayList<>();
    }

    public int getPuzzleNumber() {
        return puzzleNumber;
    }

    public int getScore() {
        return colReflection + 100 * rowReflection;
    }

    public int getScore2() {
        return colSmudgedReflection + 100 * rowSmudgedReflection;
    }

    public void addRow(String value) {
        rows.add(value);
    }

    public void addCol(String value) {
        cols.add(value);
    }

    public void getReflections() {
        colReflection = findReflection(cols, -1);
        rowReflection = findReflection(rows, -1);

        Tuple colSmudgedReflectionS = findSmudgedReflection(cols, colReflection);
        if (colSmudgedReflectionS.row >= 0)
            cols = fixSmudge(cols, colSmudgedReflectionS);

        Tuple rowSmudgedReflectionS = findSmudgedReflection(rows, rowReflection);
        if (rowSmudgedReflectionS.row >= 0)
            rows = fixSmudge(rows, rowSmudgedReflectionS);

        colSmudgedReflection = findReflection(cols, colReflection);
        rowSmudgedReflection = findReflection(rows, rowReflection);
    }

    public static List<String> fixSmudge(List<String> l, Tuple fix) {
        char[] smudged = l.get(fix.row).toCharArray();
        smudged[fix.col] = smudged[fix.col] == '#' ? '.' : '#';
        l.set(fix.row, new String(smudged));
        return l;
    }

    // Returns row number of the point of reflection
    public static int findReflection(List<String> l, int ignore) {
        int por = 0;
        for (int i = 1; i < l.size(); i++)
            if (l.get(i).equals(l.get(i - 1)) && i != ignore) {
                int res = findReflection(l, i, 0);
                por = res == 0 ? por : res;
            }
        return por;
    }

    public static int findReflection(List<String> l, int por, int n) {
        if (por - n <= 0 || por + n >= l.size())
            return por;
        if (l.get(por - 1 - n).equals(l.get(por + n)))
            return findReflection(l, por, n + 1);
        return 0;
    }

    // Need to find a single smudge that if fixed would create a new point of
    // reflection, ignoring the previously found reflection, if any.
    // So it needs to look forward to check if every possible smudge would be a new
    // PoR.
    public static Tuple findSmudgedReflection(List<String> l, int ignore) {
        Tuple result = new Tuple(-1, -1);
        l = new ArrayList<>(l);
        for (int i = 1; i <= l.size(); i++) {
            if (i == ignore)
                continue;
            if (findSmudgedReflection(new ArrayList<>(l), i, 0, 0) > 0) {
                // this i is a new PoR row number, figure out where the smudge is
                for (int j = 0; j + i < l.size() && i - j > 0; j++) {
                    int ss = findSingleSmudge(l.get(i - 1 - j), l.get(i + j));
                    if (ss > -1)
                        return new Tuple(i - 1 - j, ss);
                }
            }
        }
        return result;
    }

    public static int findSmudgedReflection(List<String> l, int por, int n, int smudges) {
        if ((por - 1 - n < 0 || por + n >= l.size()))
            return smudges == 1 ? por : 0;
        int ind = findSingleSmudge(l.get(por - 1 - n), l.get(por + n));
        if (ind != -1 && smudges == 0) {
            l = fixSmudge(l, new Tuple(por - 1 - n, ind));
            return findSmudgedReflection(l, por, n + 1, 1);
        }
        if (!l.get(por - 1 - n).equals(l.get(por + n)))
            return 0;
        return findSmudgedReflection(l, por, n + 1, smudges);
    }

    // Returns index of the character that needs to swap to make two strings equal.
    // Returns -1 if there are more than 1 differences.
    public static int findSingleSmudge(String s1, String s2) {
        int differenceCount = 0;
        int index = -1;
        for (int i = 0; i < s1.length(); i++) {
            if (s1.charAt(i) != s2.charAt(i)) {
                differenceCount++;
                index = i;
                if (differenceCount > 1)
                    return -1;
            }
        }
        return index;
    }
}

// Holds row index and column index
class Tuple {
    public int row;
    public int col;

    public Tuple(int r, int c) {
        this.row = r;
        this.col = c;
    }
}
