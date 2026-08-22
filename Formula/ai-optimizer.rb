class AiOptimizer < Formula
  desc "macOS health and maintenance CLI for AI coding environments"
  homepage "https://github.com/nyldn/ai-optimizer"
  url "https://github.com/nyldn/ai-optimizer/releases/download/v0.1.2/ai-optimizer-0.1.2.tar.gz"
  sha256 "757922c4e02adf606ec621cb60c7767ee58a227cb5d46664f62eff22e75e480e"
  license "MIT"

  depends_on macos: :ventura
  depends_on "ruby"

  def install
    inreplace "bin/ai-optimizer",
              "#!/usr/bin/env ruby",
              "#!#{formula_opt_bin("ruby")}/ruby"
    bin.install "bin/ai-optimizer"
    lib.install "lib/ai_optimizer.rb", "lib/ai_optimizer"
    prefix.install "VERSION"
  end

  test do
    assert_match "ai-optimizer #{version}", shell_output("#{bin}/ai-optimizer version")
    output = shell_output("#{bin}/ai-optimizer doctor --json")
    assert_match '"product":"ai-optimizer"', output
    assert_match '"schema_version":1', output
  end
end
