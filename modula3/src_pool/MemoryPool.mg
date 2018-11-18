UNSAFE GENERIC MODULE MemoryPool(Elem);

CONST

  poolSize = 100;

TYPE

  Drop = RECORD
    value: Elem.T;
    next: UNTRACED REF Drop := NIL;
  END;

  Pool = RECORD
    first: UNTRACED REF Drop := NIL;
  END;

VAR

  pool: Pool;

PROCEDURE Allocate() =
VAR
  drop: UNTRACED REF Drop;
BEGIN
  FOR i := 1 TO poolSize DO
    drop := NEW(UNTRACED REF Drop, next := pool.first);
    pool.first := drop;
  END;
END Allocate;

PROCEDURE Create(): UNTRACED REF Elem.T =
VAR result: UNTRACED REF Elem.T;
BEGIN
  WITH first = pool.first DO
    IF first = NIL THEN
      Allocate();
    END;
    result := LOOPHOLE(ADR(first.value), UNTRACED REF Elem.T);
    first := first.next;
  END;
  RETURN result;
END Create;

PROCEDURE Dispose(e: UNTRACED REF Elem.T) =
VAR
  drop := LOOPHOLE(e, UNTRACED REF Drop);
BEGIN
  drop.next := pool.first;
  pool.first := drop;
END Dispose;

BEGIN
  Allocate();
END MemoryPool.