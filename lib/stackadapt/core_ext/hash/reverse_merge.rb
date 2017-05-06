module StackAdapt
  module CoreExt
    class Hash
      module ReverseMerge
        def deep_reverse_merge(other_hash)
          dup.deep_reverse_merge!(other_hash)
        end

        def deep_reverse_merge!(other_hash)
          other_hash.each_pair do |current_key, other_value|
            this_value = self[current_key]

            new_value = if this_value.is_a?(::Hash) && other_value.is_a?(::Hash)
              this_value.deep_reverse_merge(other_value)
            else
              other_value
            end

            self.merge!(current_key => new_value)
          end

          self
        end

        def reverse_merge(other_hash)
          other_hash.merge(self)
        end

        def reverse_merge!(other_hash)
          # right wins if there is no left
          merge!(other_hash) { |key,left,right| left }
        end
      end
    end
  end
end

Hash.include StackAdapt::CoreExt::Hash::ReverseMerge
