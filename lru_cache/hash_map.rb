require_relative 'hashing'
require_relative 'linked_list'

class HashMap
  include Enumerable

  attr_accessor :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    linked_list_bucket = bucket(key)
    linked_list_bucket.include?(key)
  end

  def set(key, val)
    linked_list_bucket = bucket(key)
    if include?(key)
      linked_list_bucket.update(key, val)
    else
      resize! if count == num_buckets
      linked_list_bucket.append(key, val)
      self.count += 1
    end
  end

  def get(key)
    linked_list_bucket = bucket(key)
    linked_list_bucket.get(key)
  end

  def delete(key)
    linked_list_bucket = bucket(key)
    self.count -= 1 if linked_list_bucket.remove(key)
  end

  def each
    store.each do |linked_list_bucket|
      linked_list_bucket.each { |link| yield [link.key, link.val] }
    end

  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    store.length
  end

  def resize!
    old_store = store
    self.store = Array.new(num_buckets * 2) { LinkedList.new }
    self.count = 0

    old_store.each do |bucket|
      bucket.each { |link| set(link.key, link.val) }
    end
  end

  def bucket(key)
    store[key.hash % num_buckets]
  end
end
