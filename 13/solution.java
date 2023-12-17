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
                    currentPuzzle = new Puzzle(puzzleNumber);
                    puzzleNumber += 1;
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
        for (Puzzle puzzle : puzzles) {
            puzzle.getReflections();
            score = score + puzzle.getScore();
        }
        System.out.println("Part 1: " + score);
    }
}

class Puzzle {
    private int puzzleNumber;
    private List<String> rows;
    private List<String> cols;
    private int colReflection;
    private int rowReflection;

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

    public List<String> getRows() {
        return rows;
    }

    public List<String> getCols() {
        return cols;
    }

    public void addRow(String value) {
        rows.add(value);
    }

    public void addCol(String value) {
        cols.add(value);
    }

    public void getReflections() {
        System.out.println("\npuzzle: " + puzzleNumber);
        for (int i = 0; i < rows.size(); i++)
            System.out.println(rows.get(i));
        colReflection = FindReflection(cols);
        if (colReflection > 0)
            System.out.println("Column POR: " + colReflection);
        rowReflection = FindReflection(rows);
        if (rowReflection > 0)
            System.out.println("Row POR: " + rowReflection);
    }

    public static int FindReflection(List<String> l) {
        int por = 0;
        for (int i = 1; i < l.size(); i++) {
            if (l.get(i).equals(l.get(i - 1))) {
                System.out.println("I think " + l.get(i) + " equals " + l.get(i - 1));
                int res = FindReflection(l, i, 0);
                por = res == 0 ? por : res;
            }
        }
        return por;
    }

    public int FindReflection(List<String> l, int por, int n) {
        int max = l.size();
        // System.out.println("o: " + por + ", n: " + n);
        if (por - n <= 0 || por + n >= max)
            return por;
        if (l.get(por - 1 - n).equals(l.get(por + n)))
            return FindReflection(l, por, n + 1);
        else
            return 0;

    }
}
