public import Memory_Region
public import Storage

extension Storage.Contiguous: Store.Ledgered.`Protocol`
where Allocation: Memory.Region & ~Copyable, Element: ~Copyable {}
