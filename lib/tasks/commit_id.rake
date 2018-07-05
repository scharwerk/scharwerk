namespace :commit_id do
  desc 'save commit_id from git_log to DB'
  task :save_to_db => :environment do
    begin
      stages = [Task.stages[:markup], Task.stages[:markup_complex]]
      tasks = Task.commited.where('tasks.stage IN (?)', stages)
      tasks.where(commit_id: nil).each do |task|
        begin
          task.commit_id = GitDb.new.latest_commit(task.tex_file_name)
          task.save

          p [task.id, task.commit_id]
        rescue Git::GitExecuteError => exc
          p ['Probably no such path in git log', task.id]
        end
      end
    end
  end

  desc 'remove all commit_id from DB'
  task :remove_from_db => :environment do
    Task.all.where.not(commit_id: nil).each do |task|
      task.commit_id = nil
      task.save
    end
  end
end
