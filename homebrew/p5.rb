require "formula"

class P5 < Formula
  homepage "https://github.com/hamstergene/p5"
  head "https://github.com/hamstergene/p5.git"

  depends_on "python3"
  depends_on "homebrew/binary/perforce"

  def install
    bin.install "p5" => "p5"
  end
end

