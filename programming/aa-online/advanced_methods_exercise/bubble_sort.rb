def bubble_sort(arr)
  sorted = true
  while (sorted)
    sorted = false
    (0...arr.length).each do |i|
      if (i < arr.length-1 && arr[i] > arr[i+1])
        sorted = true
        arr[i], arr[i+1] = arr[i+1], arr[i]
      end
    end
  end
  arr
end


p bubble_sort([9,3,23,654,12,3,55,1,0])
