# compile latex
class Latex
  def self.call(cmd)
    child = Subprocess.popen(cmd, stdout: Subprocess::PIPE,
                                  stderr: Subprocess::PIPE)
    output, err = child.communicate
    err + output
  end

  def self.pdf_to_png(source, out)
    FileUtils.mkdir_p(out)
    FileUtils.rm_r Dir.glob(out + '/*')
    out = out + '/' + Time.now.to_i.to_s
    call(['pdftoppm', source, out, '-png', '-r', '200'])
  end

  def self.compile_tex(path, pdf)
    cmd = ['docker', 'exec', 'latex_daemon',
           'lualatex', '--interaction=nonstopmode', 
           '--output-directory=' + path, 'main.tex']
    out = call(cmd)
    return :success if File.exist?(pdf)
    
    File.write(pdf + '.err', out)
    return :fail
  end

  def self.temp_dir(filename)
    path = File.dirname(filename)
    File.join(path, File.basename(filename, File.extname(filename)))
  end

  def self.prepare_tex(filename)
    dir = temp_dir(filename)
    FileUtils.mkdir_p(dir)
    FileUtils.rm_r Dir.glob(dir + '/*.pdf')
    FileUtils.rm_r Dir.glob(dir + '/*.png')

    content = '\documentclass{kapital} \begin{document} '\
              '\input{../' + File.basename(filename) + '}' +
              ' \end{document}'
    File.write(File.join(dir, 'main.tex'), content)
    File.join(dir, 'main.pdf')
  end

  def self.build(rel_path, images_path, path)
    pdf = self.prepare_tex(path)
    status = self.compile_tex(rel_path, pdf)
    return :fail if status == :fail
    self.pdf_to_png(pdf, images_path)
    return :success
  end

end
