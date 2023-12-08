#include <stdio.h>
#include <ctype.h>
#include <stdbool.h>
#include <stdlib.h>
#define MAX_SIZE 1000
#define INPUT "input"

int lines = 0;
int columns = 0;

struct PartNumber {
   int startrow;
   int startcol;
   int length;
   int value;
};

struct NumericalTestResult {
   bool isNumber;
   struct PartNumber PartNumber;
};

// Function to check for a Number
struct NumericalTestResult TestNumber(char *row, int startIndex) {
   struct NumericalTestResult result;
   struct PartNumber partNumber;
   char *resultStr = malloc(sizeof(row));
   if (isdigit(row[startIndex])){
      result.isNumber = true;
      int places = 1;
      // Check for multi-digit numbers
      for (int i = 1; i<(columns - startIndex); i++) {
         if (isdigit(row[i+startIndex])) {
            places++;
         }
         else {
            i = columns;
         }
      }
      // reallocate only enough memory for result string
      resultStr = realloc(resultStr, places);
      for (int i = 0; i < places; i++) {
         resultStr[i] = row[i+startIndex];
      } 
      partNumber.startcol = startIndex;
      partNumber.length = places;
      partNumber.value = atoi(resultStr);      
   }
   else {
      result.isNumber = false;
   }
   result.PartNumber = partNumber;
   return result;
}

bool IsSymbol(char c) {
   return (!isalnum(c) && c != '.' && c != '\n');
}

bool ValidPartNumber(int startRow, int startCol, int length, int rows, int cols, char (*schematic)[cols+1]) {
   int start = startCol;
   int end = start + length-1;
   int row = startRow;

   for (int k = start; k <= end; k++) {
      if (row - 1 >= 0) {
         //Upper left
         if (k - 1 >= 0 && IsSymbol(schematic[row-1][k-1]))
            return true;
         //Above
         if (IsSymbol(schematic[row-1][k]))
            return true;
         //Upper right
         if (k + 1 < cols && IsSymbol(schematic[row-1][k+1]))
            return true;
      }
      //Right
      if (k + 1 < cols && IsSymbol(schematic[row][k+1])) 
         return true;
      if (row + 1 < rows) {
         //Lower right
         if (k + 1 < cols && IsSymbol(schematic[row+1][k+1]))
            return true;
         //Under
         if (IsSymbol(schematic[row+1][k]))
            return true;
         //Lower left
         if (k - 1 >= 0 && IsSymbol(schematic[row+1][k-1]))
            return true;
      }
      //Left
      if (k - 1 >= 0 && IsSymbol(schematic[row][k-1]))
         return true;
   }
   return false;
}

int FindGearRatio(int row, int col, int rows, int cols, int (*numberMap)[cols]) {
   int adjacents[12];
   adjacents[0] = adjacents[4] = adjacents[6] = adjacents [10] = 0;
   if (row - 1 >= 0) {
         //Upper left
         adjacents[1] = (col - 1 >= 0) ? numberMap[row-1][col-1] : 0;
         //Above
         adjacents[2] = numberMap[row-1][col];
         //Upper right
         adjacents[3] = (col + 1 >= 0) ? numberMap[row-1][col+1] : 0;
      }
      else {
         adjacents[1] = adjacents[2] = adjacents[3] = 0;
      }
      //Right
      adjacents[5]= (col + 1 < cols) ? numberMap[row][col+1] : 0;
      if (row + 1 < rows) {
         //Lower right
         adjacents[7] = (col + 1 < cols) ? numberMap[row+1][col+1] : 0;
         //Under
         adjacents[8] = numberMap[row+1][col];
         //Lower left
         adjacents[9] = (col - 1 >= 0) ? numberMap[row+1][col-1] : 0;
      }
      else {
         adjacents[7] = adjacents[8] = adjacents[9] = 0;
      }
      //Left
      adjacents[11] = (col - 1 >= 0) ? numberMap[row][col-1] : 0;
      int a = 0;
      int b = 0;
      int i = 0;
      do {
         if (adjacents[i] > 0 && a == 0)
            a = adjacents[i];
         else if (i != 0 && adjacents[i-1] == 0 && a != 0 && b == 0)
            b = adjacents[i];
         i++;
      } while (a * b == 0 && i < 12);
      return a * b;  
}

int main() {
   FILE *fp;
   char filename[] = INPUT;
   char ch;
   int row = 0, col = 0, colsPerRow = 0;
   char tempArray[MAX_SIZE][MAX_SIZE];
   // Read data from input file to a temporary array.
   fp = fopen(filename, "r");
   while ((ch = fgetc(fp)) != EOF) {
      tempArray[row][col] = ch;
      col++;
      if (ch == '\n') {
         colsPerRow = colsPerRow == 0 ? col : colsPerRow;
         row++;
         col = 0;
      }
   }
   fclose(fp);
   // Resize the array to match data size
   char schematic[row+1][colsPerRow];
   for (int i = 0; i <= row; i++) {
      for (int j = 0; j < colsPerRow; j++) {
         schematic[i][j] = tempArray[i][j];
      }
   }

   lines = sizeof(schematic)/sizeof(schematic[0]);
   columns = sizeof(schematic[0])-1;
  // printf("Number of lines: %d\n", lines);
  // printf("Number of columns: %d\n", columns);
   int partCount = 0;
   int grandTotal = 0;
   int numberMap[lines][columns];

   for (int i = 0; i < lines; i++) {
      for (int j = 0; j < columns; j++) {
         struct NumericalTestResult result = TestNumber(schematic[i], j);
         if (result.isNumber == true) {
            result.PartNumber.startrow = i;
            for (int k = j; k < j+result.PartNumber.length; k++) {
               numberMap[i][k] = result.PartNumber.value;
            }
            j = j + result.PartNumber.length;
            numberMap[i][j] = 0;
            if (ValidPartNumber(result.PartNumber.startrow, result.PartNumber.startcol, result.PartNumber.length, lines-1, colsPerRow-1, schematic)) {
               partCount++;
               grandTotal = grandTotal + result.PartNumber.value;
            }
         }
         else
         {
            numberMap[i][j] = 0;
         }
      }
   }
   
   printf("Part 1: %d\n", grandTotal);
   long gearRatioTotal = 0;
   for (int i = 0; i < lines; i++) {
      for (int j = 0; j < columns; j++) {
         if (schematic[i][j] == '*') {
            gearRatioTotal = gearRatioTotal + FindGearRatio(i, j, lines, colsPerRow-1, numberMap);
         }
      }
   }
   printf("Part 2: %d\n", gearRatioTotal);
   return 0;
}
