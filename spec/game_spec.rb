require "rspec"
require "./lib/game"

RSpec.describe Game do

  before(:each) do
    @game = Game.new
  end

  describe "#initialize" do #AJP
    it "exists" do
      expect(@game).to be_an_instance_of(Game)
    end

    it "each game has a computer-board and a player_board" do #AJP
      expect(@game.player_board).to be_an_instance_of(Board)
      expect(@game.computer_board).to be_an_instance_of(Board)
    end

    it "each game has two ships for the player and two for the computer" do 
      expect(@game.player_cruiser).to be_an_instance_of(Ship)
      expect(@game.player_submarine).to be_an_instance_of(Ship)
      expect(@game.computer_cruiser).to be_an_instance_of(Ship)
      expect(@game.computer_submarine).to be_an_instance_of(Ship)
    end
  end

  xdescribe "#play_game" do #AJP
    it "should loop should continue until the game is over" do
      expect(@game.game_over?).to eq(false)
      @game.play_game
      expect(@game.game_over?).to eq(true)
    end
  end

  xdescribe "#player_board_setup" do #AJP
    it "should add 2 ships to the board" do
      expect(@player_board.cells.values.all? { |cell| cell.empty? }).to eq(true)
      @game.player_board_setup
      expect(@player_board.cells.values.all? { |cell| cell.empty? }).to eq(false)
      expect(@player_board.cells.values.count { |cell| cell.empty? == false }).to eq(5)
    end
  end

  describe "#computer_board_setup" do #AJP
    it "should add 2 ships to the board" do #AJP
      expect(@game.computer_board.cells.values.all? { |cell| cell.empty? }).to eq(true)
      @game.computer_board_setup
      expect(@game.computer_board.cells.values.all? { |cell| cell.empty? }).to eq(false)
      expect(@game.computer_board.cells.values.count { |cell| cell.empty? == false }).to eq(5)
    end
  end

  describe "#random_placement" do #AR
    it "should return and array of valid coordinates" do
      coord_array = @game.random_placement(@game.computer_board, @game.computer_cruiser)
      coord_array.each do |coord|
        expect(@game.computer_board.valid_coordinate?(coord)).to eq(true)
      end
    end

    it "has the correct number of coordinates compared to ship length" do #AR
      coord_array = @game.random_placement(@game.computer_board, @game.computer_cruiser)
      expect(coord_array.length).to eq @game.computer_cruiser.length
    end

    it "gives a valid placement" do #AR
      coord_array = @game.random_placement(@game.computer_board, @game.computer_cruiser)
      expect(@game.computer_board.valid_placement?(@game.computer_cruiser, coord_array)).to eq(true)
      @game.computer_board.place(@game.computer_cruiser, coord_array)
      coord_array2 = @game.random_placement(@game.computer_board, @game.computer_submarine)
      expect(@game.computer_board.valid_placement?(@game.computer_submarine, coord_array2)).to eq(true)
    end
  end

  describe "#game_over?" do #AJP
    it "return true only if both ships belonging to 1 player are sunk" do
      expect(@game.game_over?).to eq(false)
      3.times { @game.player_cruiser.hit }
      expect(@game.player_cruiser.sunk?).to eq(true)
      expect(@game.game_over?).to eq(false)
      2.times { @game.player_submarine.hit }
      expect(@game.player_submarine.sunk?).to eq(true)
      expect(@game.game_over?).to eq(true)
    end
  end

  xdescribe "#computer_won?" do #AR
    it "" do
    end
  end

  xdescribe "#player_won?" do #AR
    it "" do
    end
  end

  describe "#winner" do #AR
    it "Will return the correct string ('You') if computer's ships have sunk" do
      @game.player_board.place(@game.player_cruiser, ["A1", "A2", "A3"])
      @game.player_board.place(@game.player_submarine, ["B1", "B2"])
      @game.computer_board.place(@game.computer_cruiser, ["A1", "A2", "A3"])
      @game.computer_board.place(@game.computer_submarine, ["B1", "B2"])
      @game.computer_board.cells["A1"].fire_upon
      @game.computer_board.cells["A2"].fire_upon
      @game.computer_board.cells["A3"].fire_upon
      @game.computer_board.cells["B1"].fire_upon
      @game.computer_board.cells["B2"].fire_upon
      expect(@game.computer_cruiser.sunk?).to eq(true)
      expect(@game.computer_submarine.sunk?).to eq(true)
      expect(@game.winner).to eq("You")
    end

    it "Will return the correct string ('I') if player's ships have sunk" do #AR
      @game.player_board.place(@game.player_cruiser, ["A1", "A2", "A3"])
      @game.player_board.place(@game.player_submarine, ["B1", "B2"])
      @game.computer_board.place(@game.computer_cruiser, ["A1", "A2", "A3"])
      @game.computer_board.place(@game.computer_submarine, ["B1", "B2"])
      @game.player_board.cells["A1"].fire_upon
      @game.player_board.cells["A2"].fire_upon
      @game.player_board.cells["A3"].fire_upon
      @game.player_board.cells["B1"].fire_upon
      @game.player_board.cells["B2"].fire_upon
      expect(@game.winner).to eq("I")
    end
  end

  xdescribe "#board_display" do #AR
    it "displays player ships but not computer ships" do
      @game.player_board.place(@game.player_cruiser, [A1, A2, A3])
      @game.player_board.place(@game.player_submarine, [B1, B2])
      @game.computer_board.place(@game.computer_cruiser, [A1, A2, A3])
      @game.computer_board.place(@game.computer_submarine, [B1, B2])
      expect(@game.board_display).to eq "=============COMPUTER BOARD=============\n" +
                                        "  1 2 3 4 \n" +
                                        "A . . . . \n" +
                                        "B . . . . \n" +
                                        "C . . . . \n" +
                                        "D . . . . \n" +
                                        "==============PlAYER BOARD==============\n" +
                                        "  1 2 3 4 \n" +
                                        "A S S S . \n" +
                                        "B S S . . \n" +
                                        "C . . . . \n" +
                                        "D . . . . \n"
    end
  end
end
