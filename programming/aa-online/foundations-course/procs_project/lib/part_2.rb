def reverser(str, &prc)
  prc.call(str.reverse)
end

def word_changer(sentence, &prc)
  changed = sentence.split.map { |word| prc.call(word) }
  changed.join(" ")
end

def greater_proc_value(num, prc1, prc2)
  res1 = prc1.call(num)
  res2 = prc2.call(num)
  return res1 if res1 > res2
  res2
end

def and_selector(arr, prc1, prc2)
  arr.select { |el| prc1.call(el) && prc2.call(el) }
end

def alternating_mapper(arr, prc1, prc2)
  arr.map.with_index do |el, i|
    if i.even?
      prc1.call(el)
    else
      prc2.call(el)
    end
  end
end
