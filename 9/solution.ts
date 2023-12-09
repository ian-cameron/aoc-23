import * as fs from 'fs';
const FILENAME: string = 'input';
const numbersArray: number[][] = [];

function readFileLines(filePath: string): void {
  const fileContent: string = fs.readFileSync(filePath, 'utf-8');
  const lines: string[] = fileContent.split('\n');

  lines.forEach((line: string) => {
    const numbersStringArray: string[] = line.trim().split(' ');
    const numbers: number[] = numbersStringArray.map((num: string) => Number(num));
    numbersArray.push(numbers);
  });
}
function findChange(numbers: number[]) : number {
    const differences: number[] = numbers.slice(1).map((num: number, index: number) => {
        return num - numbers[index];
    });
    if (differences.reduce((acc: number, val: number) => acc + Math.abs(val), 0) === 0)
        return numbers[numbers.length - 1]; 
    return (numbers[numbers.length-1] + findChange(differences));
}

function findChange2(numbers: number[]) : number {
    const differences: number[] = numbers.slice(1).map((num: number, index: number) => {
        return num - numbers[index];
    });
    if (differences.reduce((acc: number, val: number) => acc + Math.abs(val), 0) === 0)
        return numbers[0]; 
    return (numbers[0]-findChange2(differences));
}
        
readFileLines(FILENAME);
const result: number = numbersArray.reduce((acc: number, val: number[]) => acc + findChange(val), 0);
console.log(`Part 1: ${result}`);
const result2: number = numbersArray.reduce((acc: number, val: number[]) => acc + findChange2(val), 0);
console.log(`Part 2: ${result2}`);
