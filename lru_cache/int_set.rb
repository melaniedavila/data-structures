class MaxIntSet
  attr_reader :store

  def initialize(max)
    @store = Array.new(max, false)
  end

  def insert(num)
    validate!(num)
    self.store[num] = true
  end

  def remove(num)
    validate!(num)
    self.store[num] = false
  end

  def include?(num)
    validate!(num)
    store[num] == true
  end

  private

  def is_valid?(num)
    num > 0 && num < max
  end

  def max
    store.length
  end

  def validate!(num)
    raise "Out of bounds" unless is_valid?(num)
  end
end


class IntSet
  attr_reader :store

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    self[num].push(num) unless include?(num)
  end

  def remove(num)
    target_bucket = self[num]
    target_bucket.delete(num)
  end

  def include?(num)
    target_bucket = self[num]
    target_bucket.include?(num)
  end

  private

  def [](num)
    store[num % num_buckets]
  end

  def num_buckets
    store.length
  end
end

class ResizingIntSet
  attr_accessor :count, :store

  def initialize(num_buckets = 20)
    # We pass in the second argument as a block to ensure that the same
    # object is not used as the value for all of the array elements
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    resize! if num_buckets == count
    if !include?(num)
      target_bucket = self[num]
      target_bucket.push(num)
      self.count += 1
    end
  end

  def remove(num)
    target_bucket = self[num]
    target_bucket.delete(num)
  end

  def include?(num)
    target_bucket = self[num]
    target_bucket.include?(num)
  end

  private

  def [](num)
    store[num % num_buckets]
  end

  def num_buckets
    store.length
  end

  def resize!
    old_store = store
    self.count = 0
    self.store = Array.new(num_buckets * 2) { Array.new }
    old_store.flatten.each { |num| insert(num) }
  end
end
