class CinemaDb < ActiveRecord::Migration
  def change
    create_table :films do |f|
      f.string :filmtitle
      f.integer :filmreleaseyear
    end
  end
end
