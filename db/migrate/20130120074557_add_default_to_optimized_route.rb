class AddDefaultToOptimizedRoute < ActiveRecord::Migration
  def up
    change_column :routes, :optimized, :boolean, :default => false
    Route.where("optimized IS NULL").update_all(:optimized => false)
  end

  def down
  end
end
