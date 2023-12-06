    import std.stdio, std.string, std.file, std.conv, std.algorithm, std.array, std.range;
    immutable filename = "input";
    
    void main(string[] args)
    {
        auto file = File(filename, "r");
        auto times = splitter(split(file.readln(),':')[1]);
        auto distances = splitter(split(file.readln(),':')[1]);
        file.close();
        auto data = zip(map!(to!int)(times), map!(to!int)(distances));
        ulong[] winners;
        auto app = appender(winners);
        foreach (t, r; data) {
            app.put(iota(1, t).count!(h => h * (t - h) > r));
        }
        auto result = reduce!"a * b"(app[]);
        writefln("Part 1: %d", result);
        auto t2 = to!long(strip(times.join("")));
        auto r2 = to!long(strip(distances.join("")));
        auto result2 = iota(1, t2).count!(h => h * (t2 - h) > r2);
        writefln("Part 2: %d", result2);
    }
