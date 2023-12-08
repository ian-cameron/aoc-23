program ReadFile;

var
  moves: array of Char;
  store: array of record
    key: string;
    value: array[0..1] of string;
  end;
  starts: array of string;
  ends: array of string;
  input: Text;
  c: Char;
  line: Widestring;
  key, valueStr, result: string;
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

// Find starting points
  
  j := 0;
  for i := 0 to Length(store) - 1 do
  begin
    if store[i].key[Length(store[i].key)] = 'A' then
    begin
      SetLength(starts, j + 1);
      starts[j] := store[i].key;
      j := j + 1;
    end;
  end;
  writeln(Length(starts));
  SetLength(ends, Length(starts));
  result := 'AAA';
  move := 0;
  repeat
    k := move mod (Length(moves));
    if moves[k] = 'L' then
    begin
      for j := 0 to Length(store) - 1 do
      begin
        if store[j].key = result then
        begin
   //w      WriteLn(store[j].key, ': (', store[j].value[0], ',', store[j].value[1], ')');
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
     //     WriteLn(store[j].key, ': (', store[j].value[0], ',', store[j].value[1], ')');
          result := store[j].value[1];
          Break;
        end;
      end;
    end;
    move := move+1;
  //  WriteLn('Found result ',result,' Move #', move, 'k', k);
    
  until result = 'ZZZ';
  WriteLn('Part 1: ',move)
end.


function AllWinners(arr: array of string): boolean;
var
  i: integer;
begin
  for i := 0 to Length(arr) - 1 do
  begin
    if arr[i][3] <> 'A' then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;