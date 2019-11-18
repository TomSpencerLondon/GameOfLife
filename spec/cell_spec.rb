require './lib/cell.rb'

describe Cell do
  let(:cell) { Cell.new }

  it 'can live and die' do
    cell.live!
    expect(cell.alive?).to eq true
    cell.die!
    expect(cell.alive?).to eq false
  end

  it 'takes an optional status' do
    dead_cell = Cell.new(:dead)
    expect(dead_cell.alive?).to eq false
  end
end

