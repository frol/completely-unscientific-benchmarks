program MainNew;

//Author: Ben Grasset

{$mode objfpc}{$j-}
{$modeswitch advancedrecords}
{$coperators on}{$inline on}

type
  PNode = ^Node;

  Node = record
    X, Y: Integer;
    Left, Right: PNode;
  end;

var
  NodePool: array[0..333332] of Node;
  NodeIndex: Integer = 0;

type
  Tree = record
    Root: PNode;
    function HasValue(const X: Integer): Boolean;
    procedure Insert(const X: Integer);
    procedure Erase(const X: Integer);
  end;

  function MakeNode(const IX: Integer): PNode;
  begin
    Result := @NodePool[NodeIndex];
    Result^.X := IX;
    Result^.Y := Random(High(2147483647));
    Result^.Left := nil;
    Result^.Right := nil;
    Inc(NodeIndex);
  end;

  function Merge(const Lower, Greater: PNode): PNode; overload;
  begin
    if Lower = nil then
      Exit(Greater)
    else if Greater = nil then
      Exit(Lower)
    else if Lower^.Y < Greater^.Y then
    begin
      Lower^.Right := Merge(Lower^.Right, Greater);
      Result := Lower;
    end
    else
    begin
      Greater^.Left := Merge(Lower, Greater^.Left);
      Result := Greater;
    end;
  end;

  function Merge(const Lower, Equal, Greater: PNode): PNode; inline; overload;
  begin
    Result := Merge(Merge(Lower, Equal), Greater);
  end;

  procedure Split(const Orig: PNode; var Lower, GreaterOrEqual: PNode; const Val: Integer); overload;
  begin
    if Orig = nil then
    begin
      Lower := nil;
      GreaterOrEqual := nil;
    end
    else if Orig^.X < Val then
    begin
      Lower := Orig;
      Split(Lower^.Right, Lower^.Right, GreaterOrEqual, Val);
    end
    else
    begin
      GreaterOrEqual := Orig;
      Split(GreaterOrEqual^.Left, Lower, GreaterOrEqual^.Left, Val);
    end;
  end;

  procedure Split(const Orig: PNode; var Lower, Equal, Greater: PNode; const Val: Integer); inline; overload;
  var
    EqualOrGreater: PNode;
  begin
    Split(Orig, Lower, EqualOrGreater, Val);
    Split(EqualOrGreater, Equal, Greater, Val + 1);
  end;

  function Tree.HasValue(const X: Integer): Boolean;
  var
    Lower, Equal, Greater: PNode;
  begin
    Split(Root, Lower, Equal, Greater, X);
    Result := Equal <> nil;
    Root := Merge(Lower, Equal, Greater);
  end;

  procedure Tree.Insert(const X: Integer);
  var
    Lower, Equal, Greater: PNode;
  begin
    Split(Root, Lower, Equal, Greater, X);
    if Equal = nil then
      Equal := MakeNode(X);
    Root := Merge(Lower, Equal, Greater);
  end;

  procedure Tree.Erase(const X: Integer);
  var
    Lower, Equal, Greater: PNode;
  begin
    Split(Root, Lower, Equal, Greater, X);
    Root := Merge(Lower, Greater);
  end;

var
  T: Tree;
  Cur: Integer = 5;
  Res: Integer = 0;
  Mode, I: Integer;

begin
  T.Root := nil;
  for I := 1 to 999999 do
  begin
    Mode := I mod 3;
    Cur := (Cur * 57 + 43) mod 10007;
    case Mode of
      0: T.Insert(Cur);
      1: T.Erase(Cur);
      2: if T.HasValue(Cur) then Res += 1;
    end;
  end;
  WriteLn(Res);
end.
