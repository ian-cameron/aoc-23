program ReadFile;
type
  StoreRecord = record
    key: string;
    value: array[0..1] of string;
  end;

function TestResult(res, des: string) : boolean;
begin
  if Length(des) = 1 then
  begin
    if (res[Length(res)] = des) then
    begin
      TestResult := True;
      exit;
    end
  end
  else
  begin
    if (res = des) then
    begin
      TestResult := True;
      exit;
    end
  end;
  TestResult := False;
end;

function GetMoves(moves: array of Char;
  store: array of StoreRecord;
  start: string;
  destination: string) : int64;
var
  j, k, move: integer;
  result: string;
begin
result := start;
  move := 0;
  repeat
    k := move mod (Length(moves));
    if moves[k] = 'L' then
    begin
      for j := 0 to Length(store) - 1 do
      begin
        if store[j].key = result then
        begin
          result := store[j].value[0];
          Break;
        end;
      end;
    end;
    if moves[k] = 'R' then
    begin
      for j := 0 to Length(store) - 1 do
      begin
        if store[j].key = result then
        begin
          result := store[j].value[1];
          Break;
        end;
      end;
    end;
    move := move+1;
    
  until TestResult(result,destination);
  GetMoves := move;
end;

function AllWinners(arr: array of string): boolean;
var
  i: integer;
begin
  for i := 0 to Length(arr) - 1 do
  begin
    if arr[i][3] <> 'A' then
    begin
      AllWinners := False;
      Exit;
    end;
  end;
    AllWinners := True;
end;

function FindLCM(arr: array of Longint): int64;
var
  i, j: Longint;
  maxNum, lcm: int64;
begin
  maxNum := arr[0];
  for i := 1 to Length(arr) - 1 do
  begin
    if arr[i] > maxNum then
      maxNum := arr[i];
  end;
  j := 1;
  repeat
    lcm := maxNum * j;
    j := j + 1;
    for i := 0 to Length(arr) - 1 do
    begin
      if lcm mod arr[i] <> 0 then
        Break;
      if i = Length(arr) - 1 then
      begin
        FindLCM := lcm;
        Exit;
      end;
    end;
  until False;
end;

var
  moves: array of Char;
  store: array of StoreRecord;
  starts: array of string;
  ends: array of string;
  step2: array of Longint;
  input: Text;
  c: Char;
  line: Widestring;
  key, valueStr: string;
  i, j, k: Longint;
  move: int64;
  
begin
  Assign(input, 'input');
  Reset(input);
  line := '';
  repeat
    Read(input,c);
    line := Concat(line,c)
  until(c=#13);
  // Read the first line and save each letter to the moves array
  j:=0;
  SetLength(moves, Length(line));
  for i := 1 to Length(line) do
  begin
    if (line[i] = 'L') or (line[i] = 'R') then
    begin
      moves[i - 1] := line[i];
      Inc(j);
    end
  end;
  SetLength(moves, j);

  // Skip the next line
  ReadLn(input);

  // Read the remaining lines and save them to the key-value store
  SetLength(store, 0);
  while not Eof(input) do
  begin
    ReadLn(input, line);
    key := Copy(line, 1, Pos(' ', line) - 1);
    valueStr := Copy(line, Pos('(', line) + 1, Length(line) - Pos('(', line) - 1);
    SetLength(store, Length(store) + 1);
    store[Length(store) - 1].key := key;
    store[Length(store) - 1].value[0] := Copy(valueStr, 1, 3);
    store[Length(store) - 1].value[1] := Copy(valueStr, 6, 9);
  end;
  Close(input);

  //Find part 1 (steps from AAA to ZZZ)
  move := GetMoves(moves, store, 'AAA', 'ZZZ');
  WriteLn('Part 1: ',move);

  // Part 2
  // Find starting points
  j := 0;
  k := 0;
  for i := 0 to Length(store) - 1 do
  begin
    if store[i].key[Length(store[i].key)] = 'A' then
    begin
      SetLength(starts, j + 1);
      starts[j] := store[i].key;
      Inc(j);
    end;
    if store[i].key[Length(store[i].key)] = 'Z' then
    begin
      SetLength(ends, k + 1);
      ends[k] := store[i].key;
      Inc(k);
    end;
  end;
  SetLength(step2, Length(starts));
  ends := starts;

// Find part 2 
  for i := 0 to Length(starts) - 1 do
    begin
      step2[i] := GetMoves(moves, store, starts[i], 'Z');
    end;
 
  move := FindLCM(step2);
  WriteLn('Part 2: ', move);
end.
