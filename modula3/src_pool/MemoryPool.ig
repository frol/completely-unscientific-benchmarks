UNSAFE GENERIC INTERFACE MemoryPool(Elem);

PROCEDURE Create(): UNTRACED REF Elem.T;

PROCEDURE Dispose(e: UNTRACED REF Elem.T); 

END MemoryPool.