class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def remove
    prev.next = @next if prev
    @next.prev = prev if @next
  end
end

class LinkedList
  include Enumerable

  attr_reader :head, :tail

  def initialize
    @head = Link.new
    @tail = Link.new
    @head.next = tail
    @tail.prev = head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
  end

  def first
    head.next unless empty?
  end

  def last
    tail.prev unless empty?
  end

  def empty?
    head.next == tail
  end

  def get(key)
    each { |link| return link.val if link.key == key }
  end

  def include?(key)
    any? { |link| link.key == key }
  end

  def append(key, val)
    new_link = Link.new(key, val)
    empty? ? head.next = new_link : last.next = new_link
    new_link.prev = tail.prev
    new_link.next = tail
    tail.prev = new_link
  end

  def update(key, val)
    each do |link|
      if link.key == key
        link.val = val
        return link
      end
    end
  end

  def remove(key)
    each do |link|
      if link.key == key
        link.remove
        return link.val
      end
    end
  end

  def each
    current_link = head.next
    until current_link == tail
      yield current_link
      current_link = current_link.next
    end
  end
end
