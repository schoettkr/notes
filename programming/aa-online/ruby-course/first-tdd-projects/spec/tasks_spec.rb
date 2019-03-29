require "rspec"
require "tasks"

describe Array do

  describe "#my_uniq" do
    it "returns array with unique values" do
      arr = [1, 2, 1, 3, 3]
      expect(arr.my_uniq).to eq(arr.uniq)
    end
  end

  describe "#two_sum" do
    it "finds all pairs of positions where elements at those positions sum to zero" do
      arr = [-1, 0, 2, -2, 1]
      expect(arr.two_sum).to eq([[0, 4], [2, 3]])
    end

    it "sorts the pairs dictionary wise" do
      arr = [-1, 1, 1, -1, 1]
      expect(arr.two_sum).to eq([[0, 1], [0, 2], [0, 4], [1, 3], [2, 3], [3, 4]])
    end
  end


end

describe "my_transpose" do
  it "raises an error if the matrix is not square" do
    expect { my_transpose([1, [2, 3, 4], [1,2]]) }.to raise_error("Not a square matrix")
  end

  it "transposes a square matrix (2d Array)" do
    rows = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ]

    cols = [
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8]
    ]

    expect(my_transpose(rows)).to eq(cols)
    expect(my_transpose(cols)).to eq(rows)
  end
end

describe "pick_stock" do
  subject(:stock_prices) { [10, 3, 4, 5, 6, 9, 1, 6, 3, 11, 0, 4]}

  it "should raise error if no array is passed" do
    expect { pick_stock("3,2") }.to raise_error "stock_prices is not an array"
  end

  it "should pick the most profitable pair for stock purchase" do
    expect(pick_stock(stock_prices)).to eq([6, 9])
  end

  it "should not pick a sell date before buy date" do
    expect(pick_stock(stock_prices)).to eq([6, 9])
  end

end
