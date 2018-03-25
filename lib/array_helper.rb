class ArrayHelper
  def self.find_first_unique(source_arr, arr_to_search)
    arr_to_search.find { |item| !source_arr.include? item }
  end
end
