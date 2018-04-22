# Class for managing tasks
class TaskManager
  # generate tasks for markup
  def self.generate_task3(pattern, part)
    Dir[Task.tex_path(pattern)].sort.collect do |tex_file|
      path = tex_file[Task.tex_path('').length..-5]

      stage = :markup
      stage = :markup_complex if File.basename(path).count('c') > 0

      t = Task.create(stage: stage, part: part, path: path)

      pages = File.basename(path).delete('c').gsub('_', ' ').split()
      t.pages = pages.collect do |p|
        Page.create(path: File.join(File.dirname(path), p))
      end
      t
    end
  end
end
