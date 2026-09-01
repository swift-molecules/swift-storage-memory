public import Storage
public import Store
public import Store_Initialization
public import Store_Protocol

@_documentation(visibility: public)
public enum __StorageContiguousError: Swift.Error, Sendable, Equatable {

    case overflow(capacity: Int, stride: Int)
}

extension Storage.Contiguous where Allocation: ~Copyable, Element: ~Copyable {

    public typealias Error = __StorageContiguousError
}
