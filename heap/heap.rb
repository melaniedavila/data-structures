class BinaryMinHeap
  def initialize(&prc)
    self.store = []
    self.prc = prc || Proc.new { |el1, el2| el1 <=> el2 }
  end

  def count
    store.length
  end

  def extract
    raise "there are no elements in the heap" if store.count == 0
    extracted_val = store.first

    if count > 1
      store[0] = store.pop
      self.class.heapify_down(store, 0, &prc)
    else
      store.pop
    end

    extracted_val
  end

  def peek
    raise "there are no elements in the heap" if store.count == 0
    store.first
  end

  def push(val)
    store.push(val)
    self.class.heapify_up(store, self.count - 1, &prc)
  end

  protected
  attr_accessor :prc, :store

  public
  def self.child_indices(len, parent_index)
    children = [(2 * parent_index) + 1, (2 * parent_index) + 2]
    children.delete_if { |child| child >= len }
  end

  def self.parent_index(child_index)
    raise "root has no parent" if child_index == 0
    (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    children_indices = child_indices(len, parent_idx)
    children = []
    children_indices.each { |child_idx| children.push(array[child_idx]) }

    parent = array[parent_idx]

    return array if children.all? { |child| prc.call(parent, child) <= 0 }

    # Choose smaller of two children
    swap_idx = nil
    if children.length == 1
      swap_idx = children_indices.first
    else
      swap_idx =
        prc.call(children[0], children[1]) == -1 ? children_indices[0] : children_indices[1]
    end

    array[parent_idx], array[swap_idx] = array[swap_idx], parent
    heapify_down(array, swap_idx, len, &prc)
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    return array if child_idx == 0

    parent_idx = parent_index(child_idx)
    child, parent = array[child_idx], array[parent_idx]

    return array if prc.call(child, parent) >= 0

    array[child_idx], array[parent_idx] = parent, child
    heapify_up(array, parent_idx, len, &prc)
  end
end
