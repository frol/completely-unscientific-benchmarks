UNSAFE INTERFACE Node;

TYPE

  URef = UNTRACED REF T;

  T = RECORD
    left, right: URef;
    x, y: INTEGER;
  END;

END Node.