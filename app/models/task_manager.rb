# Class for managing tasks
class TaskManager

  # generate tasks for markup
  def self.generate_task3(pattern, part)
    Dir[Task.tex_path(pattern)].sort.collect do |tex_file|
        path = tex_file[Task.tex_path('').length..-5]
        Task.create(stage: :markup, part: part, path: path)
    end
  end

end
