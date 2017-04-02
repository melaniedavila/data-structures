require_relative 'hash_map'
require_relative 'linked_list'

class LRUCache
  attr_reader :map, :prc, :max, :store
  def initialize(max, prc)
    # @map is an array of linked lists
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if map[key]
      link = map[key]
      move_link_to_end_of_list!(link)
      link.val
    else
      insert_uncached_key!(key)
    end
  end

  private

  def insert_uncached_key!(key)
    val = prc.call(key)
    new_link = store.append(key, val)
    map[key] = new_link

    eject! if count > max
    val
  end

  def move_link_to_end_of_list!(link)
    link.remove
    store.append(link.key, link.val)
  end

  def eject!
    link = store.first
    link.remove
    map.delete(link.key)
  end
end
