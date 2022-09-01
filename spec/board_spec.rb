require 'rspec'
require './lib/board'


RSpec.describe Board do
  before(:each) do
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  describe "#initialize" do
    it "is an instance of Board" do
      expect(@board).to be_an_instance_of(Board)
    end

    it "the cells attribute is a hash" do
      expect(@board.cells).to be_a(Hash)
    end

    it "the cells attribute has 16 key/value pairs" do
      expect(@board.cells.length).to eq 16
    end

    it "the cells attribute keys point to Cell objects" do
      values = @board.cells.values
      values.each do |value|
        expect(value).to be_a(Cell)
      end
    end
  end

  describe "#valid_coordinate?" do
    xit "returns true/false depending on whether arg is a valid coordinate on the board" do
      expect(@board.valid_coordinate?("A1")).to eq(true)
      expect(@board.valid_coordinate?("D4")).to eq(true)
      expect(@board.valid_coordinate?("A5")).to eq(false)
      expect(@board.valid_coordinate?("E1")).to eq(false)
      expect(@board.valid_coordinate?("A22")).to eq(false)
    end
  end

  describe "#valid_placement?" do
    xit "takes two arguments, the ship object and array of coordinates" do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A3"])).to eq true
    end

    xit "requires ship length to equal coordinates length" do
      expect(@cruiser.length).to eq(3)
      expect(@board.valid_placement?(@cruiser, ["A1", "A2"])).to eq(false)
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A3"])).to eq(true)
    end

    xit "the coordinates are consecutive" do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A3"])).to eq(true)
      expect(@board.valid_placement?(@cruiser, ["A1", "B1", "C1"])).to eq(true)
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to eq(false)
      expect(@board.valid_placement?(@cruiser, ["A1", "B1", "D1"])).to eq(false)
    end
    # xit "coordinates can't be in reverse consecutive order" do
    #   expect(@board.valid_placement?(cruiser, ["A1", "A2", "A3"])).to eq(true)
    #   expect(@board.valid_placement?(cruiser, ["A3", "A2", "A1"])).to eq(false)
    # end
    xit "the coordinates can't be diagonal" do
      expect(@board.valid_placement?(cruiser, ["A1", "A2", "A3"])).to eq(true)
      expect(@board.valid_placement?(cruiser, ["A1", "B2", "C3"])).to eq(false)
    end

    xit "the coordinates can't overlap that of another ship" do
      @board.place(@cruiser, ["A1", "A2", "A3"])
      expect(@board.valid_placement?(@submarine, ["B1", "B2"])).to eq(true)
      expect(@board.valid_placement?(@submarine, ["A1", "B1"])).to eq(false)
    # xit "If the previous checks pass, then valid_placement? should be true" do
    #   expect(@board.valid_placement?(@cruiser, ["B1", "C1", "D1"])).to eq(true)
    #   expect(@board.valid_placement?(@submarine, ["A1", "A2"])).to eq(true)
    # end
  end

  describe "#place" do
    it "takes two arguments and updates the cell objects inside @cells" do 
      expect(@board.cells["A1"].empty?).to eq true
      expect(@board.cells["A2"].empty?).to eq true
      expect(@board.cells["A3"].empty?).to eq true
      @board.place(@cruiser, ["A1", "A2", "A3"]) 
      expect(@board.cells["A1"].ship).to eq @cruiser
      expect(@board.cells["A2"].ship).to eq @cruiser 
      expect(@board.cells["A3"].ship).to eq @cruiser
      expect(@board.cells["A1"].empty?).to eq false
      expect(@board.cells["A2"].empty?).to eq false
      expect(@board.cells["A3"].empty?).to eq false
    end
  end

  describe "#render" do
    it "renders empty board correctly" do 
      expect(@board.render).to eq "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
    end 

    it "renders board with ship correctly depending on boolean argument" do 
      @board.place(@cruiser, ["A1", "A2", "A3", "A4"])
      expect(@board.render).tp eq "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
      expect(@board.render(true)).to eq "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n"
    end 

    it "renders board with miss correctly" do 
      @board.place(@cruiser, ["A1", "A2", "A3"])
      expect(@board.render).tp eq "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
      @board.cells["A4"].fire_upon 
      expect(@board.render).tp eq "  1 2 3 4 \nA . . . M \nB . . . . \nC . . . . \nD . . . . \n"
    end

    it "renders board with hit correctly" do 
      @board.place(@cruiser, ["A1", "A2", "A3"])
      expect(@board.render).tp eq "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
      @board.cells["A3"].fire_upon 
      expect(@board.render).tp eq "  1 2 3 4 \nA . . H . \nB . . . . \nC . . . . \nD . . . . \n"
    end

    it "renders board with sunk ship correctly" do 
      @board.place(@cruiser, ["A1", "A2", "A3"])
      expect(@board.render).tp eq "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
      @board.cells["A3"].fire_upon 
      @board.cells["A2"].fire_upon
      expect(@board.render).to eq "  1 2 3 4 \nA . H H . \nB . . . . \nC . . . . \nD . . . . \n"
      @board.cells["A1"].fire_upon 
      expect(@board.render).to eq "  1 2 3 4 \nA X X X . \nB . . . . \nC . . . . \nD . . . . \n"
    end
  end
end