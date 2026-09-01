import Affine_Standard_Library_Integration
public import Cardinal
public import Cardinal_Carrier
public import Cardinal_Tagged
public import Index
public import Memory
public import Ordinal
public import Ordinal_Cardinal
public import Ordinal_Comparison
public import Ordinal_Protocol
public import Ordinal_Tagged
public import Storage
public import Store
public import Store_Initialization
public import Store_Protocol
public import Tagged
public import Tagged_Carrier

extension Storage.Contiguous where Allocation: Memory.Region & ~Copyable, Element: ~Copyable {

    @inlinable
    public subscript(slot: Index<Element>) -> Element {
        _read {
            let pointer = unsafe _ptr(at: slot)
            yield unsafe pointer.pointee
        }
        _modify {
            let pointer = unsafe _ptr(at: slot)
            yield &(unsafe pointer.pointee)
        }
    }

    @inlinable
    public mutating func initialize(at slot: Index<Element>, to element: consuming Element) {
        unsafe _ptr(at: slot).initialize(to: element)
        _initialization = .linear(count: count + .one)
    }

    @inlinable
    public mutating func move(at slot: Index<Element>) -> Element {
        let element = unsafe _ptr(at: slot).move()
        _initialization = .linear(count: count.subtract.saturating(.one))
        return element
    }
}

extension Storage.Contiguous where Allocation: Memory.Region & ~Copyable, Element: ~Copyable {

    @inlinable
    package func _isValidPrefixTailRemoval(range removed: Swift.Range<Index<Element>>) -> Bool {
        guard initialization.isPrefixShaped, !removed.isEmpty else { return true }
        return removed.upperBound == Index<Element>(_unchecked: Ordinal(initialization.count.underlying))
    }

    @inlinable
    public mutating func deinitialize(at slot: Index<Element>) {
        let removed = slot..<slot + Tagged<Element, Cardinal>.one
        assert(
            _isValidPrefixTailRemoval(range: removed),
            "Storage.Contiguous.deinitialize(at:): slot is not the ledger's tail — move(at:)'s "
                + "linear-prefix self-maintenance is truthful only for LIFO (tail) removal; a "
                + "non-tail removal must re-sync `initialization` explicitly "
                + "(Store.Ledgered.Protocol)"
        )
        _ = move(at: slot)
    }

    @inlinable
    public mutating func deinitialize(range: Swift.Range<Index<Element>>) {
        assert(
            _isValidPrefixTailRemoval(range: range),
            "Storage.Contiguous.deinitialize(range:): range is not the ledger's tail range — "
                + "move(at:)'s linear-prefix self-maintenance is truthful only for LIFO (tail) "
                + "removal; a non-tail removal must re-sync `initialization` explicitly "
                + "(Store.Ledgered.Protocol)"
        )
        var slot = range.lowerBound
        while slot < range.upperBound {
            _ = move(at: slot)
            slot += Tagged<Element, Cardinal>.one
        }
    }
}

extension Storage.Contiguous: Store.`Protocol`
where Allocation: Memory.Region & ~Copyable, Element: ~Copyable {}
