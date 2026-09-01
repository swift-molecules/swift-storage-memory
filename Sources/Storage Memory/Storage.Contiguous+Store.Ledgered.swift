public import Memory
public import Storage
public import Store
public import Store_Ledgered
public import Store_Initialization
public import Store_Protocol

extension Storage.Contiguous: Store.Ledgered.`Protocol`
where Allocation: Memory.Region & ~Copyable, Element: ~Copyable {}
