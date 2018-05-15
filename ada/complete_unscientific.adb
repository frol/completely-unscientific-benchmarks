with Ada.Integer_Text_IO;
with Ada.Text_IO;

with Tree; use Tree;

procedure Complete_Unscientific is
  t: Tree.Tree;
  cur: Integer := 5;
  res: Integer := 0;
  mode: Integer;
  procedure PutI(item: Integer; width: Natural := 0; base: Natural := 10)
    renames Ada.Integer_Text_IO.Put;
  procedure New_Line(spacing: Ada.Text_IO.Positive_Count := 1) renames Ada.Text_IO.New_Line;
begin
  initialize;
  for i in 1..999999 loop
    mode := i mod 3;
    cur := (cur * 57 + 43) mod 10007;
    if mode = 0 then insert(t, cur);
    elsif mode = 1 then erase(t, cur);
    else res := res + (if hasValue(t, cur) then 1 else 0);
    end if;
  end loop;
  PutI(res); New_Line(1);
end Complete_Unscientific;