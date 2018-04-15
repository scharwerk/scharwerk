# compile latex
class Latex
  def self.check_all(cmd)
    child = Subprocess.popen(cmd, stdout: Subprocess::PIPE,
                                  stderr: Subprocess::PIPE)
    output, err = child.communicate
    raise err unless child.wait.success?
    output
  end

  def self.pdf_to_png(source, out)
    FileUtils.mkdir_p(out)
    FileUtils.rm_r Dir.glob(out + '/*')
    out = out + '/' + Time.now.to_i.to_s
    check_all(['pdftoppm', source, out, '-png', '-r', '200'])
  end

  def self.compile_tex(path)
    cmd = ['docker', 'exec', '-it', 'latex_daemon',
           'lualatex', '--interaction=nonstopmode', 
           '--output-directory=' + path, 'main.tex']
    check_all(cmd)
  end

  def self.prepare_tex(filename)
    path = File.dirname(filename)
    dir = File.join(path, File.basename(filename, File.extname(filename)))
    FileUtils.mkdir_p(dir)
    FileUtils.rm_r Dir.glob(dir + '/*')

    content = '\documentclass{kapital} \begin{document} '\
              '\input{../' + File.basename(filename) + '}' +
              ' \end{document}'
    File.write(File.join(dir, 'main.tex'), content)
    File.join(dir, 'main.pdf')
  end

  def self.build(rel_path, images_path, path)
    pdf = self.prepare_tex(path)
    self.compile_tex(rel_path)
    self.pdf_to_png(pdf, images_path)
  end

end
