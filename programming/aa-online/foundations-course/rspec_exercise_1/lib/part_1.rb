def average(num1, num2)
  (num1 + num2) / 2.0
end

def average_array(array)
  array.sum / array.length.to_f
end


def repeat(string, repetitions)
  string * repetitions
end


def yell(string)
  string.upcase + "!"
end

def alternating_case(sentence)
  arr = sentence.split(" ")
  arr.map!.with_index do |el, i|
    i.even? ? el.upcase : el.downcase
  end
  return arr.join(" ")
end
