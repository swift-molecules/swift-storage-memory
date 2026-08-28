public import Memory
public import Storage

extension Storage.Contiguous: Store.Ledgered.`Protocol`
where Allocation: Memory.Region & ~Copyable, Element: ~Copyable {}
