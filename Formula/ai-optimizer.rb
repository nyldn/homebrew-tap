class AiOptimizer < Formula
  desc "macOS health and maintenance CLI for AI coding environments"
  homepage "https://github.com/nyldn/ai-optimizer"
  url "https://github.com/nyldn/ai-optimizer/releases/download/v0.1.5/ai-optimizer-0.1.5.tar.gz"
  sha256 "d630a894eb7fd69ef4feac54656b947ddfdf15cefb4fe9d018198b1bd673ad46"
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
