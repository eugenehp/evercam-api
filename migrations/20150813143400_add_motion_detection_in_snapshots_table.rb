Sequel.migration do

  up do

    alter_table(:snapshots) do
      add_column :motiondetection, :integer, null: true
    end

  end

  down do
    alter_table(:snapshots)
      drop_column :motiondetection
  end

end
