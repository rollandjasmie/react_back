class AddNoteToCommentaires < ActiveRecord::Migration[6.0]
  def change
    add_column :commentaires, :personnel, :float
    add_column :commentaires, :qualite_prix, :float
    add_column :commentaires, :proprete, :float
    add_column :commentaires, :equipement, :float
  end
end
