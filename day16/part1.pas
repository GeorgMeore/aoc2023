program part1;

uses Input;

const Left  = 1;
const Right = 2;
const Up    = 4;
const Down  = 8;

type BeamCache = array [0..Size-1] of array[0..Size-1] of integer;

procedure ClearCache(var cache: BeamCache);
var
	i, j: integer;
begin
	for i := 0 to Size-1 do
		for j := 0 to Size-1 do
			cache[i][j] := 0
end;

function CountHits(var cache: BeamCache): integer;
var
	i, j, total: integer;
begin
	total := 0;
	for i := 0 to Size-1 do
		for j := 0 to Size-1 do
			if cache[i][j] <> 0 then
				total := total + 1;
	CountHits := total
end;


type Beam = record
	x, y, d: integer
end;

type BeamState = record
	coords: array [0..Size*Size-1] of Beam;
	count: integer;
end;

procedure ClearState(var beams: BeamState);
begin
	beams.count := 0;
end;

procedure AddBeam(var beams: BeamState; x, y, d: integer; var cache: BeamCache);
begin
	if (x < 0) or (x >= Size) then
		exit;
	if (y < 0) or (y >= Size) then
		exit;
	if (cache[x][y] and d) <> 0 then
		exit;
	cache[x][y] := cache[x][y] or d;
	if (Contraption[x][y] = '|') and ((d = Left) or (d = Right)) then
	begin
		AddBeam(beams, x, y, Up, cache);
		AddBeam(beams, x, y, Down, cache);
		exit
	end;
	if (Contraption[x][y] = '-') and ((d = Up) or (d = Down)) then
	begin
		AddBeam(beams, x, y, Left, cache);
		AddBeam(beams, x, y, Right, cache);
		exit
	end;
	if (Contraption[x][y] = '/') then
		case d of
			Left:  d := Down;
			Right: d := Up;
			Up:    d := Right;
			Down:  d := Left
		end;
	if (Contraption[x][y] = '\') then
		case d of
			Left:  d := Up;
			Right: d := Down;
			Up:    d := Left;
			Down:  d := Right
		end;
	beams.coords[beams.count].x := x;
	beams.coords[beams.count].y := y;
	beams.coords[beams.count].d := d;
	beams.count := beams.count + 1;
end;

procedure calcNextPos(var x, y: integer; d: integer);
begin
	case d of
		Left:  y := y - 1;
		Right: y := y + 1;
		Up:    x := x - 1;
		Down:  x := x + 1
	end
end;

function CalcucalteEnergizement(x, y, d: integer): integer;
var
	i: integer;
	curr, next: BeamState;
	cache: BeamCache;
begin
	ClearCache(cache);
	ClearState(curr);
	AddBeam(curr, x, y, d, cache);
	while curr.count <> 0 do
	begin
		ClearState(next);
		for i := 0 to curr.count-1 do
		begin
			x := curr.coords[i].x;
			y := curr.coords[i].y;
			d := curr.coords[i].d;
			calcNextPos(x, y, d);
			AddBeam(next, x, y, d, cache)
		end;
		curr := next
	end;
	CalcucalteEnergizement := CountHits(cache)
end;

begin
	writeln(CalcucalteEnergizement(0, 0, Right))
end.
