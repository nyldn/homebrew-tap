class AiOptimizer < Formula
  desc "macOS health and maintenance CLI for AI coding environments"
  homepage "https://github.com/nyldn/ai-optimizer"
  url "https://github.com/nyldn/ai-optimizer/releases/download/v0.1.7/ai-optimizer-0.1.7.tar.gz"
  sha256 "5ddb5390cc49ba770cdb4f22e1d43ba328fe18e01132a0fcf9ef9a33d56eb539"
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

  service do
    run [opt_bin/"ai-optimizer", "run-maintenance"]
    run_type :cron
    cron "30 19 * * *"
    run_at_load false
    process_type :background
  end

  test do
    assert_match "ai-optimizer #{version}", shell_output("#{bin}/ai-optimizer version")
    output = shell_output("#{bin}/ai-optimizer doctor --json")
    assert_match '"product":"ai-optimizer"', output
    assert_match '"schema_version":1', output

    service_plist = service.to_plist
    command_pattern = %r{
      <string>#{Regexp.escape(opt_bin.to_s)}/ai-optimizer</string>\s*
      <string>run-maintenance</string>
    }x
    assert_match command_pattern, service_plist
    assert_match %r{<key>RunAtLoad</key>\s*<false/>}, service_plist
    assert_match %r{<key>Hour</key>\s*<integer>19</integer>}, service_plist
    assert_match %r{<key>Minute</key>\s*<integer>30</integer>}, service_plist
  end
end
