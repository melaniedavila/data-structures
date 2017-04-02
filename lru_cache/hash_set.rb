require_relative 'hashing'

class HashSet
  attr_accessor :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(el)
    resize! if num_buckets == count
    self[el].push(el) unless include?(el)
    self.count += 1

    el
  end

  def include?(el)
    target_bucket = self[el]
    target_bucket.include?(el)
  end

  def remove(el)
    target_bucket = self[el]
    target_bucket.delete(el)
  end

  private

  def [](num)
    store[num.hash % num_buckets]
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
