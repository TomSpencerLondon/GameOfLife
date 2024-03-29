require './lib/grid'

describe Grid do
  let(:grid) { Grid.new(3) }

  it 'accepts a dimension as an argument' do
    expect(grid.state.length).to eq 9
  end

  it 'initializes separate instances of cells' do
    expect(grid[0, 0].object_id).not_to eq(grid[0, 1].object_id)
  end

  it 'can retrieve cells from the grid' do
    grid = Grid.new(3, state: [:dead, :dead, :dead,
                                         :dead, :alive, :dead,
                                         :dead, :dead, :dead])
    expect(grid[1,1].alive?).to eq true

    grid = Grid.new(3, state: [:dead, :alive, :dead,
                                         :dead, :dead, :dead,
                                         :dead, :dead, :dead])
    expect(grid[1,0].alive?).to eq true

    grid = Grid.new(3, state: [:dead, :dead, :dead,
                                         :dead, :dead, :dead,
                                         :dead, :alive, :dead])
    expect(grid[1,2].alive?).to eq true
  end

  context 'specifying an initial state' do
    it 'accepts an initial state' do
      grid = Grid.new(2, state: [:dead, :alive, :dead, :alive])
      expect(grid[0, 0].alive?).to eq false
      expect(grid[1, 1].alive?).to eq true
    end
  end

  context 'retrieving neighboring cells' do
    it 'finds neighbors of cells away from edges' do
      expect(grid.get_neighbors_from_index(4).size).to eq 8
    end

    it 'finds neighbors of the corner cells' do
      expect(grid.get_neighbors_from_index(0).size).to eq 3
      expect(grid.get_neighbors_from_index(2).size).to eq 3
      expect(grid.get_neighbors_from_index(6).size).to eq 3
      expect(grid.get_neighbors_from_index(8).size).to eq 3
    end

    it 'finds neighbors of the edge cells' do
      expect(grid.get_neighbors_from_index(1).size).to eq 5
      expect(grid.get_neighbors_from_index(3).size).to eq 5
      expect(grid.get_neighbors_from_index(5).size).to eq 5
      expect(grid.get_neighbors_from_index(7).size).to eq 5
    end
  end

  context 'printing the grid' do
    it 'renders the live and dead cells' do
      grid = Grid.new(2, state: [:dead, :alive, :alive, :dead])
      expected_grid ="   o\n o  \n"
      expect(grid.to_s).to eq expected_grid
    end
  end

  context 'rule 1: any live cell with fewer than two live neighbors dies' do
    specify 'a sole survivor dies' do
      grid = Grid.new(2, state: [:dead, :dead,
                                           :dead, :alive])
      grid.generate!

      expect(grid.state).to eq [:dead, :dead,
                                :dead, :dead]
    end

    specify 'two sole survivors die' do
      grid = Grid.new(2, state: [:dead,  :dead,
                                           :alive, :alive])
      grid.generate!

      expect(grid.state).to eq [:dead, :dead,
                                :dead, :dead]
    end
  end

  context 'rule 2: any live cell with two or three live neighbors lives' do
    specify 'any live cell with two live neighbors lives' do
      grid = Grid.new(2, state: [:dead,  :alive,
                                           :alive, :alive])
      grid.generate!

      expect(grid.state).to eq [:alive, :alive,
                                :alive, :alive]
    end

    specify 'any live cell with three live neighbors lives' do
      grid = Grid.new(2, state: [:alive, :alive,
                                           :alive, :alive])
      grid.generate!

      expect(grid.state).to eq [:alive,  :alive,
                                :alive,  :alive]
    end
  end

  context 'rule 3: a live cell dies with more than three live neighbors' do
    specify 'a cell dies with four live neighbors' do
      grid = Grid.new(3, state: [:alive, :alive, :dead,
                                           :alive, :alive, :alive,
                                           :dead,  :dead,  :dead])
      grid.generate!

      expect(grid.state).to eq [:alive, :dead,  :alive,
                                :alive, :dead,  :alive,
                                :dead,  :alive, :dead]
    end
  end

  context 'rule 4: a dead cell with extactly three live neighbors lives' do
    specify 'a dead cell lives with three live neighbors' do
      grid = Grid.new(2, state: [:dead,  :alive,
                                           :alive, :alive])

      grid.generate!

      expect(grid.state).to eq [:alive, :alive,
                                :alive, :alive]
    end
  end

  context 'big grids' do
    specify 'big grids respect all four rules' do
      big_grid = Grid.new(5, state: [
        :alive, :alive, :alive, :alive, :alive,
        :alive, :alive, :alive, :alive, :alive,
        :alive, :alive, :alive, :alive, :alive,
        :alive, :alive, :alive, :alive, :alive,
        :alive, :alive, :alive, :alive, :alive
      ])

      big_grid.generate!

      expect(big_grid.state).to eq [
        :alive, :dead, :dead, :dead, :alive,
        :dead,  :dead, :dead, :dead, :dead,
        :dead,  :dead, :dead, :dead, :dead,
        :dead,  :dead, :dead, :dead, :dead,
        :alive, :dead, :dead, :dead, :alive
      ]

      big_grid.generate!

      expect(big_grid.state).to eq [
        :dead,  :dead, :dead, :dead, :dead,
        :dead,  :dead, :dead, :dead, :dead,
        :dead,  :dead, :dead, :dead, :dead,
        :dead,  :dead, :dead, :dead, :dead,
        :dead,  :dead, :dead, :dead, :dead
      ]
    end
  end
end

