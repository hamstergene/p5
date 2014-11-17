require "formula"

class P5 < ScriptFileFormula
  url 'https://raw.githubusercontent.com/hamstergene/p5/v0.5/p5'
  sha1 '406accd6f84cfbce582cd6a1e38034ab731b8a49'
  version '0.5'
  homepage 'https://github.com/hamstergene/p5'

  depends_on "python3"
  depends_on "homebrew/binary/perforce"
end

