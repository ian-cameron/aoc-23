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
   printf("Number of lines: %d\n", lines);
   printf("Number of columns: %d\n", columns);
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
      printf("\nLine %d maped: ", i+1);
      for (int h = 0; h < columns; h++)
      {
         printf("%d,",numberMap[i][h]);
      }
   }
   
   printf("\nPart 1: %d\n", grandTotal);
   int gears = 0;
   for (int i = 0; i < lines; i++) {
      for (int j = 0; j < columns; j++) {
         if (schematic[i][j] == '*') {
            gears++;
         }
      }
   }
   printf("Part 2: %d", gears);
   return 0;
}
