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
    check_all(['pdftoppm', source, out, '-png'])
  end
end
